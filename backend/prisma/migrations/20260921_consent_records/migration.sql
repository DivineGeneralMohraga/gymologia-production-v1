-- A queryable, per-purpose consent register (DPDP Act 2023 s.6 -- consent
-- must be specific per purpose, not one blanket "terms accepted" flag).
--
-- Hand-written, like every migration here: this database also holds the
-- legacy v1 tables, so `migrate diff` would propose dropping all of them.
--
-- Append-only in the same sense audit_logs is: every change of mind is a
-- new row, granted = false included, so nothing is overwritten. The
-- current state for a purpose is the latest row for that (userId, purpose)
-- pair -- there is deliberately no update path, only inserts.

CREATE TYPE "ConsentPurpose" AS ENUM (
  'TERMS_OF_USE',
  'PRIVACY_POLICY',
  'PROGRESS_MONITORING',
  'GUARDIAN_CONSENT'
);

CREATE TABLE IF NOT EXISTS public.consent_records (
  id         uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  "userId"   uuid NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  purpose    "ConsentPurpose" NOT NULL,
  granted    boolean NOT NULL,
  version    varchar(32),
  metadata   jsonb,
  ip         varchar(64),
  "userAgent" varchar(300),
  "createdAt" timestamp(3) NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS consent_records_user_purpose_idx
  ON public.consent_records ("userId", purpose, "createdAt");

-- RLS, matching every other table here: on, with no policies, because the
-- Data API is not used and the right answer for who may read these over it
-- is nobody. The application connects as the table owner and bypasses it.
ALTER TABLE public.consent_records ENABLE ROW LEVEL SECURITY;
