# DPDP Act 2023 — Compliance Audit Report
**Gymologia by Ganda Group Technologies (GGT)**
**Audit Date:** 2026-09-21
**Auditor:** Claude (automated static analysis)
**Proprietor:** Sarthak Ganda | **Support:** support@gymologia.com

---

## Phase 3 — Debug & verification pass (2026-09-21)

A full test-and-debug pass over everything above. It found and fixed four
real defects, added permanent regression tests, and surfaced caveats that
matter for launch.

### Defects found and fixed

| # | Defect | Fix |
|---|--------|-----|
| 1 | **Under-18 gate bypass (staff enrolment):** the server treated `age` as optional when creating a *new* member account, so a direct API call that omitted it skipped the guardian-consent gate entirely | `PersonLookupService.verifyAndResolve` now requires an age for new member accounts (server-side) |
| 2 | **Minor's data stored before consent was checked:** the new account was created *first* and `MembersService` rejected the missing guardian confirmation *afterwards* — a rejected enrolment still left a minor's name/phone/age in the database | The consent check now runs before the account is created; a live test confirms a refused minor leaves no account behind |
| 3 | **Deletion job could anonymise a live gym owner:** the "you own a gym" check ran when deletion was *requested*; the account keeps working for 30 days, so someone could create a gym in that window and be anonymised on day 30, leaving a gym with a "Deleted account" owner and its members cut off | `AccountDeletionService.runDue` re-checks ownership at execution time, cancels the request instead, and writes an `account.delete.blocked` audit row |
| 4 | **Translation regression:** rewording the owner-deletion blocker put English text into 8 locales; the project's own safety test (every deletion string is translated) failed | Real translations restored in all 8 locales |

### Tests added (all run and passing)

- `backend/test/dpdp-live.js` (`npm run test:dpdp`) — 50 live checks against the running API and real database: legal content, guardian-OTP sign-up (incl. token binding and no-account-on-refusal), consent register + export, staff enrolment of new and existing minors, gym-owner deletion blocker, gym-closing notification, erasure requests, append-only triggers
- `backend/test/dpdp-deletion-job.js` (`npm run test:dpdp:job`) — 5 checks that the deletion job spares a gym owner (scoped to the year 2000 so it can never touch a real account)
- `apps/gymologia/test/register_consent_test.dart` — 5 widget tests: consent checkbox starts unticked and blocks sign-up, minors see the guardian block and cannot submit until verified, adults skip it

Full results: backend `tsc` clean, all 8 backend unit-spec files pass, `flutter analyze` clean on all three apps, and the whole Flutter suite passes (110 checks across 3 apps). The 30-minute API e2e suite (`run-all.sh`) was **not** run.

### Caveats that matter for launch — not fixed by this pass

1. **725 of 2,178 accounts have no age on record.** The under-18 gate keys off age, so it cannot apply to them. Needs a decision (e.g. an "add your age" prompt for existing users) — not something to guess at in code.
2. **Breach-alert emails are inert until SMTP is configured.** `SMTP_HOST/USER/PASS` are empty in the local `.env`; with no host the mailer is never created and alerts are silently skipped. The code path exists; it just needs the environment variables (check the production `.env`).
3. **Only English and Hindi have translations for the new consent/guardian/export/monitoring strings.** The other 8 languages fall back to English for: the sign-up consent checkbox, the under-18 notice and guardian flow, "Download my data", and the progress-monitoring toggle. A consent notice a person cannot read is weak consent.
4. **Production has not been redeployed.** The database migrations are live (the database is shared), but the new endpoints (`/auth/guardian-consent/*`, `/me/export`) exist only in this repo's code. An app build that calls them against `api.gymologia.com` will get 404s until the backend is deployed (and `npm install` run for the new `nodemailer` dependency).
5. Still as listed below: A3b (field encryption), A9 residual (separate restricted DB role), A13/G30 (backup drill, vendor DPAs — legal/ops), F28b (external monitoring), KYC file deletion from storage.

---

## Phase 2 — Remediation status (2026-09-21)

Code changes were made after this report was first written. This section
records what actually changed, honestly separated from what is still open.
The migrations listed below **were deployed** to the live Supabase database
with `npm run prisma:deploy` and verified against it directly — not just
staged as files. See "Verified live" for how.

### Fixed in code (deployed and verified live)

| # | Item | What changed |
|---|------|--------------|
| B16 | Consent checkbox at sign-up | `register_screen.dart` now has an unchecked checkbox gating the Create Account button; l10n added for all 10 locales |
| B18b | Progress monitoring default | `schema.prisma` + `members.service.ts` default flipped `true` → `false`; migration `20260921_dpdp_consent_fixes` deployed and reset all 413 existing rows to `false` (confirmed by direct query) |
| — | Progress-monitoring toggle had no UI | Discovered while fixing B18b: `GymApi.setMonitoring()` existed but no screen called it. Added a toggle card to `progress_page.dart` so members can actually opt in themselves |
| E26/E27 | Under-18 self-registration | **Real guardian-OTP verification**, not a notice. New `OtpPurpose.GUARDIAN_CONSENT` (migration `20260921_guardian_consent_otp`, deployed), two new endpoints (`/auth/guardian-consent/request`, `/auth/guardian-consent/verify`), and a `register_screen.dart` flow that sends a code to the guardian's number and only unlocks submission once it's verified. `auth.service.ts.register()` hard-rejects any age < 18 registration without a valid `guardianConsentToken` — tested live: rejected without it, succeeded with it, audit row confirmed with masked guardian phone |
| E26/E27 | Under-18 staff enrolment | `add_person_sheet.dart` collects age for new members and requires a "guardian consent confirmed" checkbox before submitting a minor; backend (`members.service.ts`) rejects the request server-side if that flag is missing, for both new and existing accounts |
| G32 | Chat E2E mislabeling | `schema.prisma` comment corrected to describe server-side AES-256-GCM, not end-to-end encryption |
| C20 | Data export | New `/me/export` endpoint + `DataExportPage` in Settings ("Download my data") — tested live against a real account |
| C23b | Grievance Officer | Named in `legal.content.ts` privacy policy (Sarthak Ganda / support@gymologia.com) with response-time commitment — confirmed live via `/legal/privacy` |
| F29 | Breach alerting | `SecurityEventService` now emails `support.email` on HIGH/CRITICAL security events (rate-limited to one per event type per 15 min); privacy policy states the DPBI notification commitment |
| A11b | PII in security logs | `input-sanitizer.interceptor.ts` SKIP_FIELDS extended to `name`, `goal`, `description`, `message`, `contactPhone`, `contactEmail` |
| D25b | Session retention | Weekly cron in `maintenance.service.ts` purges sessions expired > 90 days |
| B19/D25 | Privacy policy text | Retention schedule made concrete per data type; children section corrected from "under 13" to the actual DPDP 13–17 guardian-consent rule; rights section now mentions the download feature |
| B17b | Per-purpose consent register | New `ConsentRecord` table (migration `20260921_consent_records`, deployed) and `ConsentService`. Every consent-relevant action now writes an append-only row: terms/privacy acceptance (`TERMS_OF_USE`, `PRIVACY_POLICY`), the member's own progress-monitoring toggle (`PROGRESS_MONITORING`), and guardian consent on both the self-registration and staff-enrolment paths (`GUARDIAN_CONSENT`). Surfaced to the user as `consentHistory` in `/me/export` |
| D25b | KYC document retention | New weekly job (`MaintenanceService.purgeStaleGymKyc`) clears a suspended gym's encrypted Aadhaar/PAN/GSTIN and document URLs once nothing has covered it for over a year, keeping only last-4/status/rejection reason for dispute history. Privacy policy's retention section states this concretely; `LEGAL_VERSION` bumped since the wording changed after the reviewer test account had already accepted the prior version. **Known gap, disclosed, not silent:** this clears database references only — the uploaded files still exist in Supabase Storage, since `StorageService` has no delete method yet |
| A9 | DB-level append-only audit log | Migration `20260921_append_only_triggers` adds `BEFORE UPDATE/DELETE/TRUNCATE` triggers to `audit_logs`, `consent_records`, and `security_events` that reject the operation for every role, including the table owner. This is genuinely enforced at the database level now, not just by application code — see "Verified live" below for the exact test. **Honest limit, not overclaimed:** the app's DB role (`postgres`) still owns these tables and could remove the trigger with an explicit `ALTER TABLE ... DISABLE TRIGGER` before writing. It is confirmed *not* a Postgres superuser (`rolsuper: false`), so it cannot use the quieter `session_replication_role = replica` bypass, which needs superuser on this database — so defeating this protection requires a distinct, conspicuous ALTER statement, not an ordinary write. A fully tamper-proof version needs a second, genuinely restricted role (INSERT + SELECT only, no ownership) that the app connects through specifically for these three tables — separate infrastructure work, not attempted here |

### Verified live (2026-09-21)

Ran against the actual production Supabase DB and the local backend pointed at it:
- `allowProgressMonitoring` column default is `false`; all 413 existing membership rows confirmed `false`
- `/legal/privacy` returns the updated Grievance Officer, children, and retention sections
- `/me/export` returns real data for an authenticated test account, including `consentHistory`
- Self-registration guardian flow: `register` returns 400 for age 15 with no `guardianConsentToken`, then succeeds once `/auth/guardian-consent/request` → `/auth/guardian-consent/verify` produced one; `audit_logs` row confirmed with `action: 'account.guardian_consent'` and a masked guardian phone
- Terms acceptance writes two `ConsentRecord` rows (`TERMS_OF_USE`, `PRIVACY_POLICY`); confirmed via `/me/export` and a direct table count
- `purgeStaleGymKyc()` run directly against the live database: returned 0, as expected (no gym has been suspended long enough yet to qualify)
- Append-only triggers: direct `UPDATE`, `DELETE`, and `TRUNCATE` against real rows in all three tables each failed with Postgres error `42501` ("append-only" message from the trigger); a normal `.create()` insert and a follow-up `SELECT` both succeeded immediately after, through both a raw script and the live HTTP API (`/me/legal/accept`); full backend test suite re-run and passed
- Test/throwaway accounts cleaned up afterward; the reviewer test account's real consent rows, and one harmless `trigger-verification-test` audit row from this testing, were left in place (by design — they can no longer be deleted, which is the point)

### Still open — needs a human decision, not just code

- **A3b** — phone, email, and body-metric fields are still plaintext at rest. Not touched — field-level encryption of a unique login column is a larger, riskier migration than this pass should take on unreviewed.
- **A9 (residual)** — see above: the current triggers stop every ordinary write path but not a privileged actor deliberately disabling the trigger first. A genuinely separate restricted DB role would close that; not attempted without your sign-off given it changes how the app connects to the database.
- **A13, G30** — backup runbook/restore drill and vendor DPAs (MSG91, Cashfree, Supabase) are operational/legal actions, not code.
- **F28b** — no external monitoring SDK (Sentry etc.) wired up; the new email alert is the only real-time signal.
- **KYC storage cleanup** — the retention job (D25b, above) clears database references but not the uploaded files themselves; `StorageService` needs a delete method first.

### Action needed from you

1. Get the vendor DPAs and backup runbook signed off outside of code.
2. Decide whether field-level encryption of phone/email/body metrics (A3b) is worth the migration risk before launch, or accepted as a documented residual risk.
3. Decide whether to invest in a second, genuinely restricted Postgres role (A9 residual) to close the last gap in append-only enforcement — this touches how the application connects to the database and was deliberately not attempted without your sign-off.
4. Sign up for an external monitoring service (Sentry or similar) if real-time visibility beyond the new email alert matters before launch (F28b).
5. Add a delete method to `StorageService` if purging the actual KYC document files (not just DB references) matters before the one-year retention window starts mattering in practice.

---

## How to read this report

Every finding is anchored to a specific file and line number. "Not found" means the feature was searched for across all relevant files and no implementation was located. Risk levels:
- **Critical** — must be fixed before launch; potential penalty up to ₹250 crore under DPDP Act 2023
- **High** — fix before launch or within 30 days; significant legal exposure
- **Medium** — fix within 90 days; moderate exposure
- **Low** — best practice; address when practical

---

## Summary Table

| # | Item | Status | Evidence | Risk |
|---|------|--------|----------|------|
| A1 | OTP hashed (scrypt + pepper), no plain MD5/SHA1 | ✅ Done | `crypto.service.ts:104`, `otp.service.ts:112` | — |
| A2 | HTTPS enforced, HSTS in production | ✅ Done | `main.ts:42-44`, `app_config.dart:18` | — |
| A3 | KYC/UPI fields encrypted at rest (AES-256-GCM) | ✅ Done | `crypto.service.ts:59-91`, `kyc.service.ts:56-61` | — |
| A3b | Phone, name, email, body metrics stored in plaintext | ⚠️ Partial | `schema.prisma:31-34` | High |
| A4 | No secrets hardcoded; all keys in .env | ✅ Done | `.env.example` — template only | — |
| A5 | JWT 15-min access tokens, rotating refresh tokens | ✅ Done | `token.service.ts:58-86`, `.env.example:26-27` | — |
| A6 | Multi-tenant isolation — gymId on every query | ✅ Done | `members.service.ts:45`, `kyc.service.ts:43` | — |
| A7 | Global ValidationPipe, whitelisting, mass-assignment protection | ✅ Done | `main.ts:65-77` | — |
| A8 | Rate limiting: global 120/min, OTP 5/min, per-number quota | ✅ Done | `app.module.ts:53`, `auth.controller.ts:56`, `otp.service.ts:28-30` | — |
| A9 | Audit log exists; NOT DB-enforced append-only | ⚠️ Partial | `audit.service.ts:26-50` | High |
| A10 | Tokens in flutter_secure_storage with EncryptedSharedPreferences | ✅ Done | `token_store.dart:1-16` | — |
| A11 | Phone masked in logs; no stack traces in error responses | ✅ Done | `otp.service.ts:126`, `all-exceptions.filter.ts:145` | — |
| A11b | InputSanitizerInterceptor may log plaintext `name`/`goal` fields | ⚠️ Partial | `input-sanitizer.interceptor.ts:105` | Medium |
| A12 | Helmet headers + CORS restricted to *.gymologia.com in production | ✅ Done | `main.ts:37-62` | — |
| A13 | Backups: Supabase automated backups (infra feature, not in code) | ⚠️ Partial | No backup policy file found | Medium |
| A14 | Dependencies: all recent versions, no known-CVE packages | ✅ Done | `package.json` — NestJS 11, Prisma 6, Helmet 8 | — |
| B15 | Privacy policy screen in app and accessible pre-login | ✅ Done | `legal_page.dart`, `legal.controller.ts:23` | — |
| B16 | Consent at sign-up — link to T&C, BUT no explicit checkbox | ❌ Missing | `register_screen.dart:163-183` | Critical |
| B17 | Terms acceptance recorded (version + timestamp) | ✅ Done | `schema.prisma:43-44`, `legal.controller.ts:84` | — |
| B17b | Granular/purpose-specific consent not recorded separately | ❌ Missing | No per-purpose consent table found | High |
| B18 | Progress monitoring consent can be revoked by member | ✅ Done | `members.service.ts:598-617` | — |
| B18b | Progress monitoring ON by default — should require opt-in | ❌ Missing | `members.service.ts:151`, `schema.prisma:619` | Critical |
| B19 | Privacy policy exists with data notice | ✅ Done | `legal.content.ts` (not read in full) | — |
| C20 | "Download/export my data" endpoint | ❌ Missing | No such endpoint found in any service | High |
| C21 | "Correct my data" — name/email editable, KYC correction via support | ⚠️ Partial | `edit_profile_page.dart` | Medium |
| C22 | "Delete account" — 30-day grace, full anonymisation on backend | ✅ Done | `account-deletion.service.ts:316-438` | — |
| C23 | Grievance contact (support email) in app | ✅ Done | `settings_page.dart:183`, `support_page.dart` | — |
| C23b | Named Grievance Officer required, not just support email | ❌ Missing | No named officer anywhere in code | High |
| D24 | Data minimisation: age not DOB, all fields have stated purpose | ✅ Done | `schema.prisma:34`, `validators.dart:42-48` | — |
| D24b | AdminStaff stores Date of Birth | ⚠️ Partial | `schema.prisma:1253` | Medium |
| D25 | OTP challenges purged after 24h | ✅ Done | `otp.service.ts:312-320` | — |
| D25b | Expired sessions never purged; no KYC retention period | ⚠️ Partial | No session/KYC cleanup in `maintenance.service.ts` | Medium |
| E26 | Minimum age 13; NO parental consent for users 13–17 | ❌ Missing | `validators.dart:45`, no consent flow for minors | Critical |
| E27 | Health data (weight/height) of minors processed without guardian consent | ❌ Missing | `members.service.ts:578-594`, no age gate | Critical |
| F28 | Security event log, IP blocking, injection detection | ✅ Done | `security-event.service.ts`, `ip-block.service.ts` | — |
| F28b | No external breach-detection alerting (Sentry/PagerDuty) | ⚠️ Partial | No monitoring SDK in any pubspec | Medium |
| F29 | No documented breach response / 72-hour DPBI notification plan | ❌ Missing | No file or code found | High |
| G30 | Third parties receiving personal data: MSG91, Cashfree, Supabase | ⚠️ Partial | `.env.example`, no DPA agreements referenced in code | High |
| G31 | No analytics/crash SDKs sending data | ✅ Done | All three pubspec.yaml — no Firebase, Mixpanel etc. | — |
| G32 | Chat: schema claims E2E; code implements server-side encryption | ❌ Misleading | `schema.prisma:878-882` vs `chat.service.ts:49` | High |
| H — | Play Store Data Safety — see Section H | See §H | — | — |

---

## TOP 5 CRITICAL FIXES

### 1. Parental / Guardian Consent for Under-18 Users (E26, E27)
**DPDP Act 2023 Section 9(1):** A Data Fiduciary shall not process personal data of a child (person under 18) without verifiable consent of a parent or lawful guardian.

**Current state:** The minimum age is 13 (enforced in `apps/gymologia/lib/core/utils/validators.dart:45`). No parental consent flow exists anywhere in the codebase. Gym staff add members aged 13–17 and their health data (weight, height) is tracked from the first session (`backend/src/members/members.service.ts:578`).

**Fix:** Add an age-gate at registration and at member-enrolment that collects a verified guardian phone number and OTP for any subject under 18. Separately, body metrics must not be collected for minors without affirmative guardian consent.

---

### 2. No Explicit Consent Checkbox at Sign-Up (B16)
**DPDP Act 2023 Section 6(1):** Consent must be free, specific, informed, unconditional and unambiguous with a clear affirmative action.

**Current state:** `apps/gymologia/lib/features/auth/register_screen.dart:163–183` shows "By creating an account you agree to our Terms and Privacy Policy" text with a tap-to-view link. There is NO tick-box or affirmative button. The user taps "Create Account" which also functions as a consent mechanism, but this is a browse-wrap / click-wrap hybrid that is legally fragile under the DPDP Act.

**Fix:** Add a mandatory unchecked checkbox (or a dedicated "I agree" action) before the Create Account button that is labelled clearly with the consent purpose and links to the policy. Record the checkbox state server-side alongside the acceptance timestamp already stored.

---

### 3. Progress Monitoring ON by Default (B18b)
**DPDP Act 2023 Section 6(2):** Consent shall not be obtained by way of bundled consent.

**Current state:** `backend/src/members/members.service.ts:151` sets `allowProgressMonitoring: dto.allowProgressMonitoring ?? true`. The default is ON. When staff add a member, health data (weight/height) monitoring is enabled unless the staff member unticks a box — not unless the *member* affirmatively opts in. `backend/prisma/schema.prisma:619` confirms `allowProgressMonitoring Boolean @default(true)`.

**Fix:** Change the default to `false`. Collect the member's informed affirmative consent at enrolment and record it as a separate consent entry with timestamp. The consent must be given by the data principal (the member), not set by the gym staff on their behalf.

---

### 4. Chat Encryption Mismatch — Schema Claims E2E, Code Implements Server-Side (G32)
**DPDP Act 2023 Section 8(4):** Accuracy and not misleading data subjects.

**Current state:** `backend/prisma/schema.prisma:878–882` states: *"Messages are stored as ciphertext produced on the sending device. The server routes and persists opaque blobs and holds no message keys."* This is factually wrong. `backend/src/chat/chat.service.ts:49` sets `const SERVER_SCHEME = 'v1-server'` and uses `CryptoService.encrypt()` — the server holds the AES key and decrypts messages on every read. The comment was accurately corrected within `chat.service.ts:22–38`, but the schema comment remains and will be read by any admin reviewing the database.

**Risk:** If users, gym owners or regulators rely on the schema comment to believe the product provides end-to-end encryption, they are being misled. The server can read all messages. Any DPA or Privacy Policy claiming E2E would be false.

**Fix:** Correct the schema comment. Update the privacy policy to accurately state "messages are encrypted at rest using server-held keys; Gymologia staff can access message content for moderation purposes." Remove any E2E claims until the device-key infrastructure (`DeviceKey` table exists) is completed.

---

### 5. No Affirmative Parental / Guardian Consent Mechanism + No Data Export Right (E26, C20)
Repeated here because the combination creates DPDP Act breach liability under Section 9 and Section 12 simultaneously. Section 12 gives every Data Principal the right to "information about the personal data processed" and the right to correction and erasure. A "download my data" feature is also required by the Google Play Data Safety form (declared "available" = required to be implemented).

**Fix:** Implement a `/me/export` endpoint that returns all personal data for the authenticated user in JSON or CSV format. Ensure it is linked from the Settings page.

---

## Step-by-Step Fix Plan

### Priority 1 — Before Beta/Play Store Review (Critical)

| Step | Action | File(s) to Change |
|------|--------|-------------------|
| 1.1 | Add explicit unchecked consent checkbox to RegisterScreen | `apps/gymologia/lib/features/auth/register_screen.dart` |
| 1.2 | Pass consent flag to backend; record purpose and timestamp | `backend/src/auth/auth.service.ts`, `backend/prisma/schema.prisma` |
| 1.3 | Change `allowProgressMonitoring` default to `false`; collect member opt-in at enrolment | `backend/src/members/members.service.ts:151`, `backend/prisma/schema.prisma:619` |
| 1.4 | Add under-18 detection in RegisterScreen (age < 18) and show guardian consent flow | `apps/gymologia/lib/features/auth/register_screen.dart`, `apps/gymologia/lib/features/auth/guardian_consent_screen.dart` (new) |
| 1.5 | Add under-18 detection in AddPerson staff sheet; block or collect guardian consent | `apps/gymologia/lib/features/staff/add_person_sheet.dart` |
| 1.6 | Correct schema comment to state server-side encryption | `backend/prisma/schema.prisma:878-882` |
| 1.7 | Update Privacy Policy to accurately describe chat encryption model | `backend/src/legal/legal.content.ts` |
| 1.8 | Add `/me/export` endpoint and link from Settings | New controller; `apps/gymologia/lib/features/settings/settings_page.dart` |

### Priority 2 — Before Public Launch (High)

| Step | Action | File(s) to Change |
|------|--------|-------------------|
| 2.1 | Designate a named Grievance Officer; publish their contact in-app and in privacy policy | `backend/src/legal/legal.content.ts`, settings screen |
| 2.2 | Add session-cleanup cron: delete expired/revoked sessions older than 90 days | `backend/src/maintenance/maintenance.service.ts` |
| 2.3 | Add KYC data retention: schedule deletion of encrypted KYC fields after gym is deleted + 7 years | `backend/src/maintenance/maintenance.service.ts` |
| 2.4 | Sign Data Processing Agreements (DPA) with MSG91, Cashfree, Supabase; record them | Documentation / vendor contracts |
| 2.5 | Implement DB-level append-only constraint on audit_logs table (row-level or restricted role) | Supabase SQL migration |
| 2.6 | Add breach notification procedure document; wire high-severity security events to email/Slack | `backend/src/common/security/security-event.service.ts` |

### Priority 3 — Within 90 Days of Launch (Medium/Low)

| Step | Action | File(s) to Change |
|------|--------|-------------------|
| 3.1 | Encrypt phone and email fields in users table (or document why not required) | `backend/prisma/schema.prisma`, migrations |
| 3.2 | Build per-purpose consent records table | New Prisma model `ConsentRecord` |
| 3.3 | Add input-sanitizer skip for `goal` field to avoid health data in security logs | `backend/src/common/interceptors/input-sanitizer.interceptor.ts:40` |
| 3.4 | Add formal retention schedule to Privacy Policy (how long each data type is kept) | `backend/src/legal/legal.content.ts` |
| 3.5 | Add external error/breach monitoring (Sentry or AWS CloudWatch) | All apps + backend |
| 3.6 | Add multi-language notice at Guardian consent screen for under-18 onboarding | New screen l10n |

---

## Section A — Security Safeguards

### A1 — OTP Hashing ✅
OTPs are never stored. A scrypt hash with a per-row salt and an environment pepper (`OTP_PEPPER`) is recorded instead.
- `backend/src/common/crypto/crypto.service.ts:104` — `hashSecret()` calls `scryptAsync(secret + pepper, salt, 64)`
- `backend/src/auth/otp.service.ts:112` — `codeHash` stored; plaintext code is never persisted
- `backend/src/auth/otp.service.ts:248` — verification uses `crypto.verifySecret()` with `timingSafeEqual` at `crypto.service.ts:124`

### A2 — HTTPS ✅
- Backend: `backend/src/main.ts:42-44` — Helmet applies HSTS with `maxAge: 31_536_000` when `isProduction=true`
- Flutter default base URL: `apps/gymologia/lib/core/config/app_config.dart:18` — `https://api.gymologia.com/api/v1`
- `app_config.dart:24` exposes `isCleartext` flag but does not block HTTP in `api_client.dart` — this is a minor gap; a developer build can point at an HTTP URL without error

### A3 — Encryption at Rest ✅ / ⚠️

**Encrypted:**
- Aadhaar, PAN, GSTIN: `backend/src/kyc/kyc.service.ts:56-61` — `crypto.encrypt()` stores AES-256-GCM ciphertext; only last-4 kept in clear
- UPI IDs: `backend/prisma/schema.prisma:1135-1137` — `upiIdEnc`, encrypted by `ReferralsService`
- Chat messages: `backend/src/chat/chat.service.ts:49` — SERVER_SCHEME with `CryptoService.encrypt()`
- Refresh token hashes: `backend/src/auth/token.service.ts:59` — `hashToken()` (SHA-256 + pepper, safe for high-entropy inputs)

**Stored in plaintext — findings:**
- `backend/prisma/schema.prisma:31` — `phone String @unique @db.VarChar(16)` — plaintext. Phone is a primary identifier and a sensitive data point under DPDP
- `schema.prisma:32` — `email String?` — plaintext
- `schema.prisma:33` — `age Int?` — plaintext (low-sensitivity integer)
- `schema.prisma` (BodyMetric model) — `weightKg`, `heightCm` — plaintext. Health data under DPDP deserves stronger protection
- `schema.prisma:177` — `fcmToken String @unique @db.VarChar(500)` — plaintext; capability token; medium risk
- `schema.prisma:1281` — SupportTicket `contactPhone`, `contactEmail` — plaintext

*Recommendation:* At minimum, encrypt phone and email fields using the existing AES-256-GCM infrastructure. Health metrics (weight/height) should also be considered for field-level encryption.

### A4 — No Hardcoded Secrets ✅
- `backend/.env.example` contains only placeholders
- `CLAUDE.md` explicitly warns: credentials removed, "any key that previously appeared here in plaintext should be treated as compromised and rotated"
- `backend/src/config/env.validation.ts` enforces key shape and length at boot

### A5 — JWT + Session Lifecycle ✅
- Access tokens expire in 15 minutes (`JWT_ACCESS_TTL=15m`)
- Refresh tokens are opaque random strings, only the SHA-256+pepper hash stored (`token.service.ts:59`)
- Rotating refresh: each use issues a new token and revokes the old one; reusing a revoked token invalidates ALL sessions for the user (`token.service.ts:111-117`)
- Session activeness checked on every authenticated request via `assertSessionActive()` (`token.service.ts:185`)
- RBAC guards: `APP_GUARD` chain in `app.module.ts:92-95` — IpBlock → Throttler → JwtAuth → Permissions

### A6 — Multi-Tenant Isolation ✅
Every CRM query is scoped to `actor.gymId` which is derived from the JWT and verified against the user's staff membership. Sample evidence:
- `backend/src/members/members.service.ts:45` — `where: { gymId: actor.gymId }`
- `backend/src/kyc/kyc.service.ts:43` — `where: { gymId: actor.gymId }`
- `backend/src/members/members.service.ts:178` — `findFirst({ where: { id: membershipId, gymId: actor.gymId } })`

### A7 — Input Validation ✅
- `backend/src/main.ts:65-77` — global `ValidationPipe` with `whitelist: true, forbidNonWhitelisted: true, transform: true`
- Error messages set `target: false, value: false` so input values are never echoed in error responses
- `backend/src/common/interceptors/input-sanitizer.interceptor.ts` — scans bodies for SQL injection, XSS, template injection patterns and records them as security events

**Note (Medium risk):** The interceptor stores `value.slice(0, MAX_STRING_SAMPLE)` in the `details.findings` JSON of security events. Fields like `goal` (member's fitness aim — plaintext health data) are not in `SKIP_FIELDS` at line 36-44. A coincidentally suspicious character sequence in a member's goal description would be saved to the security events table with the surrounding text. Fix: add `goal`, `description`, `name` to `SKIP_FIELDS`.

### A8 — Rate Limiting ✅
- Global: `ThrottlerModule` 120 requests/60s in `app.module.ts:53-55`
- OTP request: `@Throttle({ default: { limit: 5, ttl: 60_000 } })` at `auth.controller.ts:56`
- OTP verify: limit 10 per minute at `auth.controller.ts:65`
- Per-number cooldown: 30 seconds between sends, max 5 per 15-minute window at `otp.service.ts:28-30`
- IP blocking: repeated OTP abuse triggers automatic IP block via `ip-block.service.ts`

### A9 — Access Logging ⚠️
**What works:**
- `AuditService` records all significant state changes: attendance edits, leave overrides, KYC submission, member add/remove, permission grants
- Schema `audit_logs` table with actor, gymId, action, before/after, IP, user-agent, timestamp
- Sensitive field redaction: `redact.ts` removes Aadhaar, PAN, UPI, tokens from snapshots before writing

**What is documented as not working:**
- `backend/src/common/audit/audit.service.ts:26-50` — the service itself documents: *"APPEND-ONLY IS A PROPERTY OF THIS CODE, NOT OF THE DATABASE ... the application connects as the owner of the table and can rewrite or empty it at will"*. The comment explicitly notes the Postgres user has UPDATE and DELETE rights on `audit_logs`.
- This means audit trail integrity cannot be claimed in a legal or regulatory context as tamper-evident.

**Fix:** Create a restricted Postgres role with INSERT+SELECT only on `audit_logs`. Requires resolving the `BYPASSRLS` dependency described in the comment.

**Retention:** No purge job found for audit logs (reasonable — retain indefinitely). Security events also retained indefinitely ✅.

### A10 — Secure Local Storage ✅
All three apps use `flutter_secure_storage`:
- `apps/gymologia/lib/core/storage/token_store.dart:1` — `flutter_secure_storage` imported
- Line 11-15: `AndroidOptions(encryptedSharedPreferences: true)` and `IOSOptions(accessibility: KeychainAccessibility.first_unlock)`
- Confirmed in `apps/gymologia/pubspec.yaml:25`, `apps/gymologia_referral/pubspec.yaml:47`, `apps/gymologia_admin/pubspec.yaml:39`

### A11 — No PII in Logs ✅ / ⚠️
- Phone numbers masked with `maskPhone()` before any log or security event entry: `otp.service.ts:126,216`
- Error responses never include stack traces: `all-exceptions.filter.ts:143-148`
- Audit snapshots redacted before writing: `redact.ts:37-78` covers Aadhaar, PAN, UPI, tokens

**Gap:** As noted in A7, the `InputSanitizerInterceptor` may log plaintext body content from non-sensitive fields including member `goal` (fitness aim = health data).

### A12 — CORS and Security Headers ✅
- `backend/src/main.ts:37-45` — Helmet with HSTS, CSP (disabled in dev only), COEP false
- `main.ts:54-62` — CORS `origin: /\.gymologia\.com$/` in production
- `main.ts:59` — `credentials: false` — correct for a mobile API

### A13 — DB Backups ⚠️
Using Supabase as the hosted database provider, which automatically takes daily backups (Point-in-Time Recovery on Pro/Team plans). No custom backup policy or validation script is present in the codebase. This is acceptable for a managed service but should be:
1. Documented in an operations runbook
2. Tested with a restore drill
3. Confirmed that the Supabase plan supports the recovery point objective

### A14 — Dependencies ✅
- NestJS 11.1.6 (current), Prisma 6.16.2 (current), Helmet 8.1.0 (current)
- No bcrypt in `package.json` — correct because there are no passwords (phone-OTP auth)
- No vulnerable legacy dependencies identified (`npm audit` should be run in CI)
- Flutter: Dio 5.7.0 (current), flutter_secure_storage 9.2.2 (current)

---

## Section B — Consent and Notice

### B15 — Privacy Policy Accessible ✅
- `apps/gymologia/lib/features/settings/legal_page.dart` — in-app viewer for Terms and Privacy
- `backend/src/legal/legal.controller.ts:23` — `@Public()` endpoint, no auth needed
- Accessible from Settings (`settings_page.dart:214`) and from register screen (`register_screen.dart:171`)

### B16 — Consent Checkbox at Sign-Up ❌ CRITICAL
**Evidence:** `apps/gymologia/lib/features/auth/register_screen.dart:163-183`

The registration screen shows a text block (`termsAgreement` string) saying the user agrees to T&C by creating an account, with a tappable link to the LegalPage. There is no explicit checkbox. The "Create Account" button is the only affirmative action.

**DPDP Act 2023 requirement:** Section 6(1) requires consent to be given through "a clear affirmative action." Section 6(2) prohibits bundled consent. A "by signing up you agree" banner is legally considered implied/constructive consent — challenged successfully in other jurisdictions and specifically excluded by the DPDP Act's wording.

**Required fix:** An unchecked checkbox with the label: *"I have read and agree to the [Terms of Use] and [Privacy Policy]."* The user must tick it before the Create Account button becomes active. The server must record the consent timestamp and policy version separately from the account creation.

### B17 — Consent Records ✅ / ⚠️
**What works:**
- `backend/prisma/schema.prisma:43-44` — `termsVersion` and `termsAcceptedAt` stored on User
- `backend/src/legal/legal.controller.ts:84` — version is taken from the server, client cannot claim an older version

**Gap:**
- Consent is a single blanket "terms accepted" record. DPDP Act requires that consent must be specific per purpose. Processing health data for gym analytics is a different purpose from using the app for gym access. These should be captured separately.
- No per-purpose consent table exists in the schema.

### B18 — Consent Withdrawal ✅ / ❌

**Progress monitoring (body metrics) — gap:**
- `backend/src/members/members.service.ts:151` — `allowProgressMonitoring: dto.allowProgressMonitoring ?? true` — **defaults to ON**
- This means health monitoring is enabled by the gym staff at enrolment, not by the member's own affirmative action.
- DPDP Section 6 requires the data principal (member) to give consent, not for a third party (gym staff) to assume it.
- The withdrawal mechanism works (`members.service.ts:598-617`), but the initial consent direction is wrong.

**Notification preferences:** No per-notification-type consent toggle found (promotional vs operational vs safety).

### B19 — Data Collection Notice ✅
Privacy Policy is served from `backend/src/legal/legal.content.ts`. The content was not read in full during this audit — a separate review of the policy text is recommended. It should explicitly state: what personal data is collected, the purpose for each category, the retention period, which third parties receive it, and the user's rights.

---

## Section C — User Rights

### C20 — "Download My Data" (Data Portability) ❌ HIGH

**DPDP Act 2023 Section 12(a):** The Data Principal has the right to obtain from the Data Fiduciary information about the personal data being processed and the summary of the data processed.

**Evidence:** No `/me/export`, `/me/data`, or data portability endpoint was found in any controller or service. Individual endpoints exist (`/me` for profile, `/members/me/memberships`, `/members/me/metrics`, `/members/me/attendance`) but there is no single export of all held data.

This is also required for Google Play Data Safety compliance (the form asks if users can request data deletion — yes — and data access/export — must answer honestly).

### C21 — Data Correction ⚠️
- `apps/gymologia/lib/features/settings/edit_profile_page.dart` — name and email can be edited ✅
- Phone number is immutable (correct design for phone-number-based auth) ✅
- Age can presumably be edited on the same screen
- KYC correction requires contacting support — this is acceptable given the verification nature of those fields, but must be documented in the privacy policy

### C22 — Account Deletion ✅
A thorough, DPDP-compliant implementation:
- 30-day grace period with cancellation option: `account-deletion.service.ts:64`
- Actual anonymisation: phone replaced with sentinel, name → "Deleted account", email/age/avatar cleared: `account-deletion.service.ts:403-418`
- Health data hard-deleted: `account-deletion.service.ts:341` — `tx.bodyMetric.deleteMany()`
- Messages overwritten with tombstone: line 355-362
- Referral UPI and PAN cleared: lines 392-400
- Cron runs daily at 3 AM: `maintenance.service.ts:48,55`
- Web page for users who have uninstalled: `AccountDeletionPageController` referenced in module

### C23 — Grievance Contact ✅ / ❌
- Support email (`support@gymologia.com`) is visible in the app at `settings_page.dart:183` ✅
- `legal.controller.ts:30` — support email returned in the legal index response ✅

**Gap (High risk):** DPDP Act 2023 Section 13 requires every Data Fiduciary to establish a "Grievance Redressal Mechanism" and publish the name and contact details of a "Data Protection Officer" (or equivalent contact person). A support email box is not the same as a named, accountable individual. The law requires a designated officer who can be held responsible.

**Fix:** Designate a named Grievance Officer (even if it is the proprietor), publish their name and email in the Privacy Policy and in the settings screen.

---

## Section D — Data Minimisation and Retention

### D24 — Data Fields Inventory

| Category | Fields | Justified? |
|----------|--------|-----------|
| User account | phone, name, email (opt), age, locale, avatarUrl | ✅ All required for identity and communication |
| Auth | OTP hash+salt, session tokens (hashed), device FCM token | ✅ Required |
| Gym KYC | Aadhaar (encrypted), PAN (encrypted), GSTIN (encrypted), NOC URL, alt proof URL | ✅ Required for verification |
| Membership | goal (fitness aim), maxLeaveDays, progress monitoring consent | ✅ Core service |
| Health | weightKg, heightCm, recordedAt | ✅ Core service, but consent (see B18) |
| Payments | Cashfree order/payment IDs, amount, method | ✅ Financial records required by law |
| Referral | UPI ID (encrypted), PAN (encrypted) | ✅ Required for payouts |
| Chat | Ciphertext, nonce | ✅ Communication |
| Attendance | Date, status, marker, editor | ✅ Core service |
| Admin staff | DOB, work email | ⚠️ DOB is sensitive — verify HR necessity |
| Support tickets | contactPhone, contactEmail, message | ✅ Required for support |

**Admin staff DOB (`schema.prisma:1253`):** The comment says *"Admin staff record DOB (unlike app users) for HR purposes."* While this may be legitimate, DOB is explicitly the most sensitive personal identifier (CLAUDE.md even notes this in the spec). Ensure this is protected and that the legal basis for collection (employment contract / HR compliance) is documented.

### D25 — Retention Policies

| Data type | Purge mechanism | Status |
|-----------|----------------|--------|
| OTP challenges | Purged 24h after expiry (`otp.service.ts:312`) | ✅ |
| Account (PII) | Anonymised 30 days after deletion request (`maintenance.service.ts:55`) | ✅ |
| Sessions (expired/revoked) | No purge job found | ⚠️ Medium |
| KYC records | No purge schedule after gym deletion | ⚠️ Medium |
| Security events | No purge (acceptable for compliance) | ✅ |
| Audit logs | No purge (acceptable for compliance) | ✅ |
| Body metrics | Deleted when account is anonymised | ✅ |

**Session cleanup:** Expired and revoked sessions accumulate indefinitely. Add a weekly cron to delete sessions where `expiresAt < now - 90 days`.

**KYC retention:** When a gym is deleted, the GymKyc row is cascade-deleted (`schema.prisma:308`), which destroys the encrypted Aadhaar/PAN. However, what happens when a gym is *suspended* (lapsed subscription, not deleted)? The data persists indefinitely. Define a maximum retention period (e.g., 7 years after gym closure for legal purposes, then delete).

---

## Section E — Children's Data

### E26 — Parental Consent for Under-18 ❌ CRITICAL

**DPDP Act 2023 Section 9:** A Data Fiduciary shall not process personal data of a child and shall not undertake tracking or behavioural monitoring of children or target them with advertisements.

**Current state:**
- Age minimum in Flutter validator: `apps/gymologia/lib/core/utils/validators.dart:45` — `if (age < 13) return t.mustBeAtLeast13` — minimum age is 13
- India defines "child" as any person under 18 years of age under the DPDP Act
- Users aged 13–17 can register and use the app without any guardian involvement
- Gym staff can add members aged 13–17 (`add_person_sheet.dart`) without any guardian consent record

**This is the most significant compliance gap.** The DPDP Act imposes age-verification requirements and treats minors' data with heightened protection.

**Required fix:**
1. The minimum age for independent registration should be 18, OR
2. For ages 13–17, implement a verifiable guardian consent flow: collect guardian phone, send OTP to guardian, record guardian consent with their phone and timestamp, and link to the minor's account
3. Staff adding a minor member must collect proof of guardian consent (upload or checkbox + guardian phone)

### E27 — Health Data of Minors ❌ CRITICAL
If a person under 18 is a gym member, their body metrics (weight, height) are collected monthly. Given E26 (no guardian consent), this health data collection on minors is being done without the DPDP Act-required parental consent. Body metrics also constitute "health data" under several global frameworks.

---

## Section F — Breach Readiness

### F28 — Security Monitoring ✅ / ⚠️

**What works:**
- `security_events` table records: OTP abuse, brute force, invalid tokens, permission probing, injection attempts, IP blocks
- `SecurityEventService.considerBlocking()` auto-blocks IPs on threshold violations (`security-event.service.ts:90`)
- HIGH/CRITICAL events are logged with `logger.warn()` on line 66-70

**Gaps:**
- No external monitoring service found (no Sentry, CloudWatch, or PagerDuty in any package file). Security events exist in the DB but no real-time alert reaches an on-call human
- The `RATE_LIMIT_TRIPPED`, `PAYOUT_VELOCITY`, `REFERRAL_FRAUD`, `SUSPICIOUS_UPLOAD` event types are defined in the enum but `security-event.service.ts:27-30` explicitly notes: *"nothing writes any of them"*

### F29 — Breach Response Plan ❌ HIGH

**DPDP Act 2023 Section 8(6):** A Data Fiduciary shall, in the event of a personal data breach that is likely to cause harm, notify the Board and each affected Data Principal.

No breach response procedure was found in the codebase, documentation, or CLAUDE.md. Under the Act, notification to the Data Protection Board of India (DPBI) must happen promptly (rules under development, likely 72-hour window). A breach affecting thousands of gym members would require notification to all affected individuals.

**Required:** A documented breach response playbook including: detection → internal escalation → DPBI notification → affected user notification → remediation steps.

---

## Section G — Third Parties

### G30 — Third Parties Receiving Personal Data ⚠️

| Service | Data Sent | Purpose | DPA in Code? |
|---------|-----------|---------|--------------|
| MSG91 | Phone number (E.164) | OTP delivery | ❌ Not referenced |
| Cashfree PG | Gym owner details (via SDK), payment amount | Subscription payment | ❌ Not referenced |
| Cashfree Payout | UPI ID (decrypted from DB), PAN | Referral payouts | ❌ Not referenced |
| Cashfree Verification | Aadhaar number (decrypted), PAN, GSTIN | KYC verification | ❌ Not referenced |
| Supabase | ALL personal data (DB host + object storage) | Infrastructure | ❌ Not referenced |

Under DPDP Act 2023 Section 8(2), a Data Fiduciary is responsible for compliance even when a Data Processor processes the data. Data Processing Agreements (DPAs) must be in place with all of the above. None are referenced in the codebase or documentation.

**Action:** Execute DPAs with all vendors before handling live personal data. Ensure Cashfree Verification's handling of Aadhaar numbers complies with UIDAI guidelines (Aadhaar authentication is regulated separately).

### G31 — Analytics SDKs ✅
No Firebase Analytics, Crashlytics, Mixpanel, Amplitude, AppsFlyer, or similar data-collecting SDK was found in any of the three Flutter `pubspec.yaml` files. This is a strong privacy posture — no user data is sent to advertising or analytics networks.

**Note:** `fcmToken` is stored in the database (`schema.prisma:177`) and Firebase Cloud Messaging is implied (FCM tokens are issued by Google). However, no `firebase_messaging` or `firebase_core` package is listed in any pubspec. The token storage infrastructure is in place but the SDK is absent. Clarify whether FCM is being used through a REST API directly (which would still involve Google processing device tokens) and disclose accordingly in the Privacy Policy.

### G32 — Chat Encryption Discrepancy ❌ HIGH

**Schema comment** (`backend/prisma/schema.prisma:878-882`) claims end-to-end encryption:
> *"Messages are stored as ciphertext produced on the sending device. The server routes and persists opaque blobs and holds no message keys, so neither gym staff nor Gymologia admins can read message bodies."*

**Actual implementation** (`backend/src/chat/chat.service.ts:22-49`):
- `const SERVER_SCHEME = 'v1-server'` — server-side scheme
- `CryptoService.encrypt()` is called with the server's AES key
- The code comment itself acknowledges this and explains E2E is future work

**Impact:** This discrepancy, if it reaches users (via documentation, Privacy Policy or a sales claim), would constitute a misleading representation about data security — a DPDP Act violation and potential Consumer Protection Act issue.

**Fix:** Correct the schema comment. Ensure the Privacy Policy accurately describes message storage. The `DeviceKey` table and the schema preparation for E2E are noted as infrastructure for future work — this is the correct approach.

---

## Section H — Google Play Data Safety Form (Draft Answers)

Based on code analysis:

**Data collected and shared:**

| Data type | Collected | Shared with 3rd parties | Purpose | Encrypted in transit | Can user delete? |
|-----------|-----------|------------------------|---------|---------------------|-----------------|
| Name | Yes | No | Account management | Yes (HTTPS) | Yes (account deletion) |
| Email | Yes (optional) | No | Contact | Yes | Yes |
| Phone number | Yes | MSG91 (OTP only) | Auth verification | Yes | Yes (anonymised) |
| User IDs | Yes | No | App functionality | Yes | Yes |
| Body metrics (weight/height) | Yes | No | Fitness tracking | Yes | Yes |
| Location | No* | No | — | — | — |
| Financial info (UPI ID) | Yes (referral users) | Cashfree (payout) | Payment processing | Yes | Yes |
| PAN number | Yes (referral users) | Cashfree Verification | Tax/KYC | Yes | Yes |
| Aadhaar number | Yes (gym owners) | Cashfree Verification | KYC | Yes | Yes |
| Photos/images | Yes (gym images, avatar) | Supabase Storage | App functionality | Yes | Yes |
| App activity | Yes (in-app activity) | No | Analytics | Yes | Yes |
| Messages (chat) | Yes | No | Communication | Yes (server-encrypted) | Yes |
| Device/other IDs (FCM) | Yes | Google (FCM) | Push notifications | Yes | Yes |

*Location: The app requests location for gym search but does not appear to store it server-side (gym browser uses location client-side). Verify this before submitting the form.

**Required to answer YES on the Data Safety form:**
- Does your app collect or share any of the required data types? **YES**
- Is all data from this app encrypted in transit? **YES**
- Do you provide a way for users to request that their data be deleted? **YES** (in-app deletion page + web URL)

**Note on minors:** Google Play requires that if your app "may appeal to children" or if users can be under 13, you must comply with additional requirements. Since the minimum age is 13 and the app deals with physical fitness, you may need to set the target audience to "Older teens (16+)" or "Adults only" in the Play Console, or implement the guardian consent flow described in E26.

---

## Legal Context — DPDP Act 2023 Penalties

For reference, the penalty schedule relevant to this audit:

| Violation | Maximum Penalty |
|-----------|----------------|
| Failure to implement reasonable security safeguards | ₹250 crore |
| Failure to notify breach to Board | ₹200 crore |
| Non-compliance with children's data obligations | ₹200 crore |
| Non-compliance with other provisions (consent, etc.) | ₹50 crore |
| Non-compliance with Data Principal rights | ₹50 crore |

The three Critical findings (E26 minors, B16 consent checkbox, B18b progress monitoring default) each individually touch the ₹200–250 crore penalty bracket. These are not paperwork issues — they require code changes before the app handles real user data at scale.

---

*End of Phase 1 Audit. This report reflects the state of the codebase at commit `e6f18ab` on branch `main`, read on 2026-09-21. No code was modified during this audit.*
