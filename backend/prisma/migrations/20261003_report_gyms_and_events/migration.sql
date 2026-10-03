-- Reporting gyms and events, and taking them down.
--
-- Until now a report could only be filed against a person, from inside a
-- chat. A gym name or an event anyone near it can see had no way to be
-- flagged. A gym or event report is still filed against a person -- the
-- gym's owner, the event's creator -- so the existing desk, its history
-- counts and the account ban all keep working; `target` says what the
-- complaint is about and `eventId` points at the event.
--
-- The hide columns are for Gymologia staff only. They are not
-- `publicListing` or an EventStatus, because the gym or host can change
-- those, and a takedown must not be undone by the account it was taken
-- against.
--
-- Written idempotently, like the migrations before it.

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'ReportTarget') THEN
    CREATE TYPE public."ReportTarget" AS ENUM ('USER', 'GYM', 'EVENT');
  END IF;
END $$;

-- Postgres 12+ allows ADD VALUE inside a transaction as long as the new
-- value is not used in the same one, which nothing below does.
ALTER TYPE public."ReportCategory" ADD VALUE IF NOT EXISTS 'FAKE_LISTING' BEFORE 'OTHER';
ALTER TYPE public."ReportCategory" ADD VALUE IF NOT EXISTS 'MISLEADING' BEFORE 'OTHER';

ALTER TABLE public.gyms
  ADD COLUMN IF NOT EXISTS "listingHiddenAt" timestamp(3),
  ADD COLUMN IF NOT EXISTS "listingHiddenReason" varchar(300);

ALTER TABLE public.events
  ADD COLUMN IF NOT EXISTS "hiddenAt" timestamp(3),
  ADD COLUMN IF NOT EXISTS "hiddenReason" varchar(300);

ALTER TABLE public.content_reports
  ADD COLUMN IF NOT EXISTS "target" public."ReportTarget" NOT NULL DEFAULT 'USER',
  ADD COLUMN IF NOT EXISTS "eventId" uuid;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint WHERE conname = 'content_reports_eventId_fkey'
  ) THEN
    ALTER TABLE public.content_reports
      ADD CONSTRAINT "content_reports_eventId_fkey"
      FOREIGN KEY ("eventId") REFERENCES public.events(id)
      ON DELETE SET NULL ON UPDATE CASCADE;
  END IF;
END $$;

-- One report per person per gym, and per event. Reporting the same
-- listing twice is not more evidence, and the second tap usually means the
-- first did not look like it worked. Chat reports keep their own rule
-- (one per message) and are untouched: their gymId is only context.
CREATE UNIQUE INDEX IF NOT EXISTS content_reports_one_per_gym
  ON public.content_reports ("reporterId", "gymId")
  WHERE target = 'GYM';

CREATE UNIQUE INDEX IF NOT EXISTS content_reports_one_per_event
  ON public.content_reports ("reporterId", "eventId")
  WHERE target = 'EVENT';

-- "Everything reported about this event" on the desk.
CREATE INDEX IF NOT EXISTS content_reports_event_idx
  ON public.content_reports ("eventId")
  WHERE "eventId" IS NOT NULL;
