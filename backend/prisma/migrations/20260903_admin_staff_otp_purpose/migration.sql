-- A distinct OTP purpose for adding internal admin staff.
--
-- Written by hand for the same reason as the earlier migrations: this
-- database also holds the legacy v1 tables, so `migrate diff` against it
-- would propose dropping all of them.
--
-- Reusing ADD_STAFF would mean a code issued to add someone as gym staff
-- could be redeemed to add them to the internal console, which reads across
-- every gym on the platform. Additive; nothing existing changes.

ALTER TYPE "OtpPurpose" ADD VALUE IF NOT EXISTS 'ADMIN_STAFF_ADD';
