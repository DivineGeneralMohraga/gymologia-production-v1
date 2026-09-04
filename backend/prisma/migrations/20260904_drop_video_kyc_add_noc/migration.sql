-- Gym verification, revised: no video KYC, and a landlord NOC for rented
-- premises.
--
-- Written by hand for the same reason as every migration here: this
-- database also holds the legacy v1 tables, so `migrate diff` against it
-- would propose dropping all of them.
--
-- Verification is now three document checks -- Aadhaar, PAN, and either
-- GST or another legal proof -- plus a no-objection letter when the gym
-- rents its premises. The video call is gone from the product, so the
-- appointment table goes with it.
--
-- Safe to run on live data: no gym has completed KYC yet, so
-- kyc_sessions is empty and videoKycStatus is NOT_SUBMITTED everywhere.
-- The DROPs are still written so that a row surviving somewhere would be
-- removed deliberately rather than orphaned.

BEGIN;

-- ── The video KYC appointment ──────────────────────────────────────────
-- Dropping the table takes its foreign keys and indexes with it.
DROP TABLE IF EXISTS "kyc_sessions";
DROP TYPE IF EXISTS "KycSessionStatus";

ALTER TABLE "gym_kyc" DROP COLUMN IF EXISTS "videoKycStatus";

-- ── Premises, and the letter a tenant needs ────────────────────────────
-- Nullable rather than defaulted: an existing draft has not been asked
-- the question yet, and "we do not know" is not the same as "owned".
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'PremisesOwnership') THEN
    CREATE TYPE "PremisesOwnership" AS ENUM ('OWNED', 'RENTED');
  END IF;
END
$$;

ALTER TABLE "gym_kyc"
  ADD COLUMN IF NOT EXISTS "premises" "PremisesOwnership",
  ADD COLUMN IF NOT EXISTS "nocUrl" VARCHAR(500),
  ADD COLUMN IF NOT EXISTS "nocStatus" "VerificationStatus" NOT NULL DEFAULT 'NOT_SUBMITTED';

-- ── Proof for a business without GST ───────────────────────────────────
-- The spec says "any legal document like an electricity bill or Udyam
-- certificate", so the list stays open at the end rather than pretending
-- to enumerate every acceptable document in the country.
ALTER TYPE "AltProofType" ADD VALUE IF NOT EXISTS 'OTHER';

COMMIT;
