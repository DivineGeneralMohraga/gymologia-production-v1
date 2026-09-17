-- Deleting your account.
--
-- Google Play has required this of any app offering account creation since
-- 2023: deletion must be available inside the app AND startable from the web
-- without installing it, and the Data safety form has a field for that URL
-- which cannot be left blank. We sign people up with a phone number, so it
-- applies to all three apps.
--
-- ## Anonymise, do not DELETE
--
-- The row stays and its identifying columns are emptied. Two reasons, and
-- the second is the one that decides it:
--
--  1. Books of account have to be kept. A person who paid for a subscription
--     cannot have their payment rows vanish because they left, and those rows
--     point at the user.
--  2. An audit log whose actor pointers dangle is not an audit log. The trail
--     of who marked whose attendance, who approved which leave, who resolved
--     which report, is the record every later dispute is settled from, and it
--     is worth more than the twenty-odd bytes anonymising leaves behind.
--
-- What is emptied is everything that identifies a person: phone, name, email,
-- age, avatar, body metrics, device tokens, message bodies, UPI and PAN.
-- What survives is money, moderation history, and the audit trail, with the
-- person taken out of them.
--
-- ## The phone number is freed
--
-- It is the login identity and it is unique, so it cannot simply be blanked.
-- It is overwritten with a per-row sentinel, which releases the real number
-- for signing up again. A returning person gets a genuinely new account with
-- no history, which is the correct meaning of having deleted the old one.
--
-- ## A grace period, not an instant wipe
--
-- The request sets a date thirty days out and a scheduled job does the work.
-- Deletion is often decided in the middle of something -- an argument, a bad
-- day, somebody standing over you -- and a wipe with no way back turns a
-- moment into a permanent loss. Play permits the delay as long as it is
-- disclosed, and the app says the date plainly.
--
-- Hand-written, like every migration here: this database also holds the
-- legacy v1 tables, so `migrate diff` would propose dropping all of them.

ALTER TABLE public.users
  -- When they asked. Null means they have not.
  ADD COLUMN IF NOT EXISTS "deletionRequestedAt" timestamp(3),
  -- When the job will do it. Kept separate from the request time so the
  -- grace period can be changed later without rewriting what people were
  -- promised when they asked.
  ADD COLUMN IF NOT EXISTS "deletionScheduledFor" timestamp(3),
  -- When it was actually carried out. Non-null means this row no longer
  -- describes a person, and every query that shows a name should skip it.
  ADD COLUMN IF NOT EXISTS "anonymisedAt" timestamp(3);

-- The job's only question: whose date has passed and has not been done yet.
-- Partial, because the overwhelming majority of rows are neither.
CREATE INDEX IF NOT EXISTS users_deletion_due_idx
  ON public.users ("deletionScheduledFor")
  WHERE "deletionScheduledFor" IS NOT NULL AND "anonymisedAt" IS NULL;

-- Support needs to answer "what happened to my account" from a phone number
-- that no longer exists on any row. This is the only trace kept of the real
-- number, and it is a one-way hash: enough to confirm an account was deleted
-- when somebody asks, useless for building a list of who left.
CREATE TABLE IF NOT EXISTS public.account_deletions (
  id             uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  "userId"       uuid NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  "phoneHash"    varchar(64) NOT NULL,
  "requestedAt"  timestamp(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "scheduledFor" timestamp(3) NOT NULL,
  "completedAt"  timestamp(3),
  "cancelledAt"  timestamp(3),
  -- Which app it was asked from, so a spike in one is visible.
  "requestedVia" varchar(20) NOT NULL DEFAULT 'APP',
  -- Balance in paise at the moment of asking, if any. Kept because somebody
  -- who deletes with money owed may come back and ask for it, and "we have
  -- no record" would be a poor answer to a question we caused.
  "balancePaise" integer NOT NULL DEFAULT 0
);

CREATE INDEX IF NOT EXISTS account_deletions_user_idx
  ON public.account_deletions ("userId");
CREATE INDEX IF NOT EXISTS account_deletions_phone_idx
  ON public.account_deletions ("phoneHash");

-- RLS, matching every other table here: on, with no policies, because the
-- Data API is not used and the right answer for who may read these over it
-- is nobody. The application connects as the table owner and bypasses it.
ALTER TABLE public.account_deletions ENABLE ROW LEVEL SECURITY;
