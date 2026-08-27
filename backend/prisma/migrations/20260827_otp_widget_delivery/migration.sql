-- Adds MSG91 widget delivery as an OTP path alongside the direct API.
--
-- Written by hand rather than generated: `migrate diff` needs a shadow
-- database, and this project's database also holds the legacy v1 tables,
-- so a diff against the live schema would propose dropping all of them.
--
-- Additive only. Existing rows default to DIRECT, which is what they were.

CREATE TYPE "OtpDelivery" AS ENUM ('DIRECT', 'WIDGET');

ALTER TABLE "otp_challenges"
  ADD COLUMN "delivery" "OtpDelivery" NOT NULL DEFAULT 'DIRECT';

-- MSG91's request id, quoted back on verify. Null in DIRECT mode.
ALTER TABLE "otp_challenges"
  ADD COLUMN "providerRef" VARCHAR(120);
