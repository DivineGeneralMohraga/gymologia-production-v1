-- A distinct OTP purpose for verifying a parent/guardian's phone before a
-- self-registered under-18 account activates (DPDP Act 2023 s.9).
--
-- Written by hand for the same reason as the earlier migrations: this
-- database also holds the legacy v1 tables, so `migrate diff` against it
-- would propose dropping all of them.
--
-- Kept separate from every other purpose so a guardian-consent challenge
-- can never be redeemed against an unrelated OTP endpoint. Additive;
-- nothing existing changes.

ALTER TYPE "OtpPurpose" ADD VALUE IF NOT EXISTS 'GUARDIAN_CONSENT';
