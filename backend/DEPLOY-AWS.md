# Deploying and updating the Gymologia API on AWS

Target: **`13.232.161.2`** (ap-south-1, Mumbai).
The database is Supabase, so this box runs one stateless container. Nothing
on it needs backing up — it can be rebuilt from scratch at any time.

---

## Updating (the everyday case)

Once the first deploy below is done, shipping a change is three commands:

```bash
ssh -i <your-key>.pem ubuntu@13.232.161.2
cd /opt/gymologia
./backend/deploy.sh
```

`deploy.sh` pulls `main`, rebuilds the image, runs pending migrations in a
throwaway container, restarts the API, and waits for the health check.
**If the new build does not come healthy within five minutes it rolls back
to the previous commit automatically** and prints the container logs.

Useful while you watch:

```bash
cd /opt/gymologia/backend
docker compose logs -f api          # live logs
docker compose ps                   # is it up, is it healthy
curl localhost:3000/api/v1/health   # from on the box
```

---

## First deploy

Right now port 3000 is closed from outside and nothing is deployed, so this
part has to happen once before the update loop works.

### 1. Open the port

The instance is reachable on SSH but not on 3000, which means the security
group has no inbound rule for it. In the EC2 console:

**EC2 → Instances → select the instance → Security → click the security
group → Edit inbound rules → Add rule**

| Field | Value |
|---|---|
| Type | Custom TCP |
| Port range | `3000` |
| Source | `0.0.0.0/0` (tighten to your IP while testing) |

> This is temporary. Once nginx and TLS are in front (step 6), close 3000
> again and expose only 443.

### 2. Install Docker

```bash
ssh -i <your-key>.pem ubuntu@13.232.161.2

sudo apt update
sudo apt install -y docker.io docker-compose-v2 git
sudo usermod -aG docker ubuntu
exit                       # log out and back in for the group to apply
```

### 3. Clone the repo

```bash
ssh -i <your-key>.pem ubuntu@13.232.161.2
sudo mkdir -p /opt/gymologia && sudo chown ubuntu:ubuntu /opt/gymologia
git clone https://github.com/DivineGeneralMohraga/gymologia2test.git /opt/gymologia
chmod +x /opt/gymologia/backend/deploy.sh
```

### 4. Put the secrets on the box

Secrets live at `/etc/gymologia/api.env`, outside the repo, and are never
baked into the image — `.dockerignore` excludes `.env` from the build
context on purpose.

```bash
sudo mkdir -p /etc/gymologia
sudo nano /etc/gymologia/api.env
sudo chmod 600 /etc/gymologia/api.env
```

Use `backend/.env.production.example` as the template. **Generate fresh
values — do not copy the development ones:**

```bash
node -e "console.log('JWT_ACCESS_SECRET='+require('crypto').randomBytes(48).toString('base64url'))"
node -e "console.log('JWT_REFRESH_SECRET='+require('crypto').randomBytes(48).toString('base64url'))"
node -e "console.log('ENCRYPTION_KEY='+require('crypto').randomBytes(32).toString('hex'))"
node -e "console.log('OTP_PEPPER='+require('crypto').randomBytes(48).toString('base64url'))"
```

`ENCRYPTION_KEY` decrypts KYC numbers and UPI handles. **If you lose it or
change it later, every encrypted row becomes unreadable.** Store a copy in
a password manager before you deploy.

The app refuses to boot in production if any of these are missing, or if
`CASHFREE_ENV` is not `production` — see `src/config/env.validation.ts`.

### 5. Deploy

```bash
cd /opt/gymologia
./backend/deploy.sh
```

Then from your own machine:

```bash
curl http://13.232.161.2:3000/api/v1/health
```

Point the app at it:

```bash
cd apps/gymologia
flutter run --dart-define=API_BASE_URL=http://13.232.161.2:3000/api/v1
```

### 6. TLS, before real users

Plain HTTP means OTP codes and bearer tokens cross the network in the
clear. Fine for testing with a throwaway number, not acceptable once real
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

Then tighten things up:

1. In `docker-compose.yml`, change the port binding to
   `"127.0.0.1:3000:3000"` so the container is only reachable via nginx.
2. Remove the inbound rule for 3000 from the security group; keep 443.
3. Rebuild the apps against `https://api.gymologia.com/api/v1`.
4. Delete `android/app/src/main/res/xml/network_security_config.xml` and
   its manifest reference, plus the `NSAppTransportSecurity` block in
   `ios/Runner/Info.plist`. They exist only for cleartext testing.

---

## Rolling back by hand

`deploy.sh` rolls back on a failed health check, but if a deploy is healthy
and still wrong:

```bash
cd /opt/gymologia
git log --oneline -10
git reset --hard <good-commit>
cd backend && docker compose up -d --build
```

Migrations do **not** roll back. A migration that has to be undone needs a
new forward migration that reverses it.

---

## Before real customers

- **Rotate the MSG91 auth key and the Cashfree secrets.** Both sat in a
  plaintext file in the repo before being redacted. Treat them as burned.
- **Reset the Supabase database password.** The current one is a name plus
  a phone number, and it has been shared in chat.
- **Point Cashfree at the webhook** and set `CASHFREE_WEBHOOK_SECRET`.
  Without the secret the app cannot verify signatures, which means anyone
  who guesses the URL can mark a subscription paid. The app refuses to boot
  in production without it.
- **Drop the legacy tables** once nothing reads them. The database still
  holds 26 PascalCase tables (`"User"`, `"Gym"`, …) from the replaced v1,
  alongside the current snake_case ones.

## Operational notes

- **Connection pooling** — `DATABASE_URL` uses Supabase's transaction
  pooler with `connection_limit=1`, which is correct for containers.
  `DIRECT_URL` is for migrations only and must not be used at runtime.
- **Region** — the box is in Mumbai, the Supabase project in Singapore.
  That costs roughly 40-60ms per query. Moving one to match the other is
  the single biggest latency win available.
- **Scaling past one instance** — chat will need sticky sessions or a Redis
  adapter. One instance is fine until then.
- **Logs** — `docker compose logs -f api`. Rotation is capped at 5×10MB in
  `docker-compose.yml`, so logs cannot fill the disk.
