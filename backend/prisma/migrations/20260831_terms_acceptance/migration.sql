-- Records which version of the Terms and Privacy Policy each account accepted.
--
-- Written by hand for the same reason as the previous migration: `migrate
-- diff` needs a shadow database, and this database also holds the legacy v1
-- tables, so a diff against it would propose dropping all of them.
--
-- Additive and nullable. Existing accounts read as "has not accepted the
-- current version", which is true -- they signed up before there was one --
-- and the app asks them on next launch.

ALTER TABLE "users"
  ADD COLUMN IF NOT EXISTS "termsVersion" VARCHAR(32),
  ADD COLUMN IF NOT EXISTS "termsAcceptedAt" TIMESTAMP(3);
