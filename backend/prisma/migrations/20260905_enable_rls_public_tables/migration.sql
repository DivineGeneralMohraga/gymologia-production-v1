-- Close the Supabase Data API on every table this application owns.
--
-- Supabase publishes the `public` schema through PostgREST, reachable with
-- the anon key -- a key that is public by design and ships inside clients.
-- Row level security was off on all 40 of our tables, so that endpoint
-- served real rows to anyone who had it. Verified against the live project
-- before this was written, using nothing but the anon key:
--
--   GET /rest/v1/users           200  phone, name and email of real users
--   GET /rest/v1/otp_challenges  200  phone numbers and OTP code hashes
--   GET /rest/v1/sessions        200  session token hashes
--   GET /rest/v1/gym_kyc         200  the KYC record, ciphertext and all
--
-- The users table alone is every phone number on the platform. The OTP and
-- session rows are worse: that is the material an account takeover is made
-- of.
--
-- Nothing in this product uses the Data API. Every read and write goes
-- through the NestJS backend, which connects as `postgres` -- owner of all
-- 66 tables in the schema, with rolbypassrls set -- so enabling RLS costs
-- the application nothing while leaving anon with no way in. That was
-- checked before running this, not assumed:
--
--   select current_user, rolbypassrls  ->  postgres, true
--
-- Deliberately no policies. A policy is a decision about who may read what
-- over an interface we do not use, and the right answer for every one of
-- these tables is nobody. If the Data API is ever wanted, that is the
-- moment to write policies -- not now, and not blanket ones.
--
-- Written as a loop rather than 40 statements so a table added later by a
-- migration that forgets RLS is covered the next time this runs on a fresh
-- database. On an existing one it is a no-op: tables that already have RLS
-- are skipped.
--
-- Hand-written, like every migration here: this database also holds the
-- legacy v1 tables, so `migrate diff` would propose dropping all of them.

DO $$
DECLARE t record;
BEGIN
  FOR t IN
    SELECT tablename FROM pg_tables
    WHERE schemaname = 'public' AND NOT rowsecurity
  LOOP
    EXECUTE format('ALTER TABLE public.%I ENABLE ROW LEVEL SECURITY', t.tablename);
  END LOOP;
END
$$;
