# Deploying and updating the Gymologia API on AWS

Target: **`65.0.75.45`** (ap-south-1, Mumbai).

No Docker. The box runs Node directly, managed by `systemd` — the service
manager already built into Ubuntu. The database is Supabase, so nothing on
this machine holds state; it can be rebuilt from scratch at any time.

---

## Updating (the everyday case)

Once the first deploy below is done, shipping a change is three commands:

```bash
ssh -i <your-key>.pem ubuntu@65.0.75.45
cd /opt/gymologia
./backend/deploy.sh
```

`deploy.sh` pulls `main`, installs dependencies, compiles, applies pending
migrations, restarts the service, and waits for the health check.
**If the new build does not come healthy within 100 seconds it rolls back
to the previous commit automatically** and prints the last 60 log lines.

### When there is no remote to pull from

```bash
./backend/deploy.sh --no-pull
```

Deploys whatever is already on the box instead of fetching. Put the code
there yourself first — `rsync -az --delete ./ ubuntu@HOST:/opt/gymologia/`
from a machine that has it, or a tarball, or a git bundle.

This exists because the deploy path otherwise depends on the GitHub remote
being reachable, and it currently answers "Repository not found". Every
other prerequisite can be ready and the deploy still fails at its first
step.

**A `--no-pull` deploy cannot be rolled back.** The rollback works by
resetting to the commit that was checked out before the fetch; with no
fetch there is no earlier state to return to, because the working tree
already is the new code. The script says so at the point it would otherwise
have rolled back rather than running a reset that quietly does nothing and
reporting success. If a `--no-pull` build fails, the previous service is
left running untouched; if it starts but never becomes healthy, you are
restoring the old code by hand.

Day-to-day commands:

```bash
sudo systemctl status gymologia      # is it running
sudo systemctl restart gymologia     # restart without deploying
journalctl -u gymologia -f           # live logs
journalctl -u gymologia -n 100       # last 100 lines
curl localhost:3000/api/v1/health    # from on the box
```

---

## First deploy

Port 3000 is currently closed from outside and nothing is deployed, so
this runs once before the update loop above works.

### 1. Open the port

The instance answers on SSH but not on 3000, which means the security
group has no inbound rule for it. In the EC2 console:

**EC2 → Instances → select the instance → Security → click the security
group → Edit inbound rules → Add rule**

| Field | Value |
|---|---|
| Type | Custom TCP |
| Port range | `3000` |
| Source | `0.0.0.0/0` (tighten to your own IP while testing) |

> Temporary. Once nginx and TLS are in front (step 6), close 3000 again
> and expose only 443.

### 2. Install Node 24 and git

Ubuntu's own `apt install nodejs` ships something far too old. Use
NodeSource:

```bash
ssh -i <your-key>.pem ubuntu@65.0.75.45

curl -fsSL https://deb.nodesource.com/setup_24.x | sudo -E bash -
sudo apt install -y nodejs git
node -v          # expect v24.x
```

### 3. Clone the repo

```bash
sudo mkdir -p /opt/gymologia && sudo chown ubuntu:ubuntu /opt/gymologia
git clone https://github.com/DivineGeneralMohraga/gymologia2test.git /opt/gymologia
chmod +x /opt/gymologia/backend/deploy.sh
```

### 4. Put the secrets on the box

Secrets live at `/etc/gymologia/api.env`, outside the repo, readable only
by root and loaded by systemd at start.

```bash
sudo mkdir -p /etc/gymologia
sudo nano /etc/gymologia/api.env
sudo chmod 600 /etc/gymologia/api.env
```

Use `backend/.env.production.example` as the template. **Generate fresh
values — do not reuse the development ones:**

```bash
node -e "console.log('JWT_ACCESS_SECRET='+require('crypto').randomBytes(48).toString('base64url'))"
node -e "console.log('JWT_REFRESH_SECRET='+require('crypto').randomBytes(48).toString('base64url'))"
node -e "console.log('ENCRYPTION_KEY='+require('crypto').randomBytes(32).toString('hex'))"
node -e "console.log('OTP_PEPPER='+require('crypto').randomBytes(48).toString('base64url'))"
```

Two things about this file:

- **`ENCRYPTION_KEY` cannot be regenerated later.** It decrypts KYC numbers
  and UPI handles. Lose it or change it and those rows are unreadable
  forever. Put a copy in a password manager before you deploy.
- **No `export`, no spaces around `=`.** systemd reads this file itself,
  not through a shell. `KEY=value` or `KEY="value"` — both fine. Anything
  else silently fails to load.

The app refuses to boot in production if any required value is missing, or
if `CASHFREE_ENV` is not `production` — see `src/config/env.validation.ts`.

### 5. Install the service and deploy

```bash
sudo cp /opt/gymologia/backend/gymologia.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable gymologia      # start automatically on reboot

cd /opt/gymologia
./backend/deploy.sh
```

Then from your own machine:

```bash
curl http://65.0.75.45:3000/api/v1/health
```

Point the app at it:

```bash
cd apps/gymologia
flutter run --dart-define=API_BASE_URL=http://65.0.75.45:3000/api/v1
```

### 6. TLS, before real users

Plain HTTP means OTP codes and bearer tokens cross the network in the
clear. Fine for testing with a throwaway number; not acceptable once real
people sign in.

```bash
sudo apt install -y nginx certbot python3-certbot-nginx
sudo nano /etc/nginx/sites-available/gymologia
```

```nginx
server {
    server_name api.gymologia.com;
    location / {
        proxy_pass http://127.0.0.1:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

```bash
sudo ln -s /etc/nginx/sites-available/gymologia /etc/nginx/sites-enabled/
sudo nginx -t && sudo systemctl reload nginx
sudo certbot --nginx -d api.gymologia.com
```

`X-Forwarded-For` matters: the app runs with `trust proxy` enabled, so rate
limits and audit logs record the real client IP rather than nginx's.

Afterwards, tighten up:

1. Remove the inbound rule for 3000 from the security group; keep 443.
2. Rebuild the apps against `https://api.gymologia.com/api/v1`.
3. Delete `android/app/src/main/res/xml/network_security_config.xml` and
   its manifest reference, plus the `NSAppTransportSecurity` block in
   `ios/Runner/Info.plist`. Both exist only for cleartext testing.

---

## When something breaks

**Service will not start**

```bash
sudo systemctl status gymologia
journalctl -u gymologia -n 100 --no-pager
```

The usual cause is a missing or malformed value in `/etc/gymologia/api.env`
— the startup validator names the offending variable.

**Rolling back by hand**

`deploy.sh` rolls back on a failed health check, but if a deploy is healthy
and still wrong:

```bash
cd /opt/gymologia
git log --oneline -10
git reset --hard <good-commit>
cd backend && npm ci && npx prisma generate && npm run build
sudo systemctl restart gymologia
```

**Migrations do not roll back.** Reverting code does not revert the schema.
Undoing a migration needs a new forward migration that reverses it.

---

## Before real customers

- **Rotate the MSG91 auth key and the Cashfree secrets.** Both sat in a
  plaintext file in the repo before being redacted. Treat them as burned.
- **Reset the Supabase database password.** The current one is a name plus
  a phone number, and it has been shared in chat.
- **Point Cashfree at the webhook** and set `CASHFREE_WEBHOOK_SECRET`.
  Without it signatures cannot be verified, so anyone who guesses the URL
  can mark a subscription paid. The app refuses to boot without it.
- **Drop the legacy tables** once nothing reads them. The database still
  holds 26 PascalCase tables (`"User"`, `"Gym"`, …) from the replaced v1,
  alongside the current snake_case ones.

## Operational notes

- **Connection pooling** — `DATABASE_URL` uses Supabase's **session**
  pooler (port 5432 on the pooler host) with `connection_limit=10` and no
  `pgbouncer=true`. The transaction pooler (6543) forces Prisma's pgbouncer
  mode, which wraps every query in BEGIN / DEALLOCATE ALL / COMMIT: four
  extra round trips per query, ~60 ms each from Mumbai. Session-mode
  clients count against the pooler's Pool Size in the Supabase dashboard,
  so keep this plus any dev server on the same project under it.
- **Region** — the box is in Mumbai, the Supabase project in Singapore.
  That costs roughly 40–60 ms per query. Moving one to match the other is
  the single biggest latency win available.
- **Logs** — handled by journald, which rotates on its own. Cap the disk it
  may use with `sudo journalctl --vacuum-size=500M` if the instance is
  small.
- **Reboots** — `systemctl enable gymologia` (step 5) is what makes the API
  come back by itself after the instance restarts. Worth testing once with
  `sudo reboot`.
- **Scaling past one box** — chat will need sticky sessions or a Redis
  adapter. One instance is fine until then.

---

## If you ever want Docker instead

The Docker setup (Dockerfile, compose file, .dockerignore) was written and
then removed in favour of this simpler path. It is recoverable:

```bash
git show 12bbc4e -- backend/Dockerfile backend/docker-compose.yml
```
