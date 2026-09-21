-- DPDP Act 2023 compliance fixes (Phase 1 audit, 2026-09-21).
--
-- Progress monitoring must be the member's own affirmative opt-in
-- (s.6 -- consent cannot be given by a third party, and cannot be
-- bundled/defaulted on). The column default was `true`, set by staff at
-- enrolment on the member's behalf. This flips the default for new rows
-- AND resets every existing row: nothing in this database distinguishes a
-- member who actually chose to turn it on from one who simply inherited
-- the old default, so there is no record of genuine consent to preserve.
--
-- Hand-written, like every migration here: this database also holds the
-- legacy v1 tables, so `migrate diff` would propose dropping all of them.

ALTER TABLE public.memberships
  ALTER COLUMN "allowProgressMonitoring" SET DEFAULT false;

UPDATE public.memberships
  SET "allowProgressMonitoring" = false
  WHERE "allowProgressMonitoring" = true;
