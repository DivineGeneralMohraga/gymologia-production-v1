# Gymologia

Gym management platform: a CRM for gym owners and staff, a member app, a
referral programme, and an internal admin console — four Flutter clients on
one NestJS backend.

## Apps

| App | Audience | Status |
|---|---|---|
| **Gymologia** | Members, and gym owners/staff (mode switch in settings) | Backend foundation done |
| **Gymologia Referral** | Anyone except gym owners — earn per referred gym subscription | Schema done |
| **Gymologia Admin** | Internal staff: KYC video calls, support, logs, push | Schema done |

## Stack

- **Backend** — NestJS 11 (TypeScript), Prisma 6, PostgreSQL on Supabase
- **Clients** — Flutter 3.44 / Dart 3.12 (Android + iOS)
- **Auth** — Phone + OTP via MSG91, rotating JWT sessions
- **Payments** — Cashfree PG (subscriptions), Cashfree Payouts (referral rewards)
- **Verification** — Cashfree Verification Suite (PAN / Aadhaar / GST)

## Repository layout

```
backend/          NestJS API — the only thing that talks to the database
  prisma/
    schema.prisma 40 models, 37 enums
  src/
    auth/         OTP issuance + verification, JWT sessions, MSG91
    rbac/         Role/permission engine, guards, decorators
    common/       Crypto, audit log, security telemetry, filters
    config/       Typed env config with boot-time validation
    prisma/       PrismaService (raw-unsafe queries disabled)
apps/             Flutter clients
packages/         Shared Dart packages
docs/             Design notes
```

## Getting started

```bash
cd backend
cp .env.example .env      # fill in real values
npm install
npx prisma generate
npm run start:dev         # http://localhost:3000/api/v1
                          # Swagger at /api/v1/docs (non-production only)
```

## The permission model

The CRM runs on roles scoped to a single gym. Seniority is one integer —
**lower means more senior** (Owner 0, Manager 10, Admin 20, Sales Staff 30,
Trainer 40). Three rules govern every authorization decision:

1. **Hold** — you can only do what your role explicitly holds. Owner and
   Manager are `isSuper` and hold everything, including permissions added
   in future releases.
2. **Outrank** — you can only act on someone strictly junior to you. Peers
   and superiors are off limits, always.
3. **No escalation** — you can never grant a permission you do not hold.

`DELETE_GYM` sits outside the role system entirely: it follows `Gym.ownerId`
and cannot be granted to anyone.

## Security posture

- Every query goes through Prisma's parameterized statements.
  `$queryRawUnsafe` and `$executeRawUnsafe` are overridden to throw, so the
  door cannot be reopened by accident.
- OTP codes are never stored — only a peppered scrypt hash with a per-row
  salt. Rate limited per number, per IP, and per challenge.
- Refresh tokens are opaque and stored as hashes; rotation is enforced, and
  replaying a revoked token revokes every session for that account.
- KYC document numbers and UPI handles are AES-256-GCM encrypted at rest,
  with only the last four characters kept in clear.
- Chat messages are stored as ciphertext produced on the sending device.
  The server holds no message keys.
- `audit_logs` is append-only and redacts sensitive keys before writing.
- `security_events` records injection probes, OTP abuse, permission
  probing, and payout velocity anomalies.

## Credentials

Nothing secret is committed. All keys live in `backend/.env`, which is
gitignored; `backend/.env.example` documents every variable.

## Support

support@gymologia.com
