-- Blocking a person, and reporting them.
--
-- The chat is user-generated content: members message members, and groups
-- exist that staff cannot see into. An app that carries that and offers no
-- way to get away from somebody is missing the thing every such app needs,
-- and Google Play requires it explicitly -- a way to report objectionable
-- content and to block an abusive user. Without it the listing is at risk
-- quite apart from the person being harassed having no recourse.
--
-- ## Why a report carries text
--
-- Messages are stored as AES-GCM ciphertext and the server holds no key.
-- That is deliberate and it stays. The consequence is that a report naming
-- a message id gives a reviewer a row they cannot read, so the report also
-- carries what the REPORTER saw -- they had the plaintext on their screen,
-- and they are the one making the accusation. The message id is kept too,
-- so the account, the conversation and the timing are all verifiable even
-- though the words are not.
--
-- ## Blocks are one-directional, enforced both ways
--
-- A blocks B. B is not told. Neither can start a direct conversation with
-- the other and neither sees the other's messages -- because a block that
-- only hides one side leaves the blocker still receiving abuse, and one
-- that announces itself invites retaliation through another channel.
--
-- Hand-written, like every migration here: this database also holds the
-- legacy v1 tables, so `migrate diff` would propose dropping all of them.

-- ── Blocks ────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS public.user_blocks (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  "blockerId" uuid NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  "blockedId" uuid NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  reason      varchar(200),
  "createdAt" timestamp(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

  -- Blocking yourself is not a coherent request and would quietly break
  -- every direct conversation you are in.
  CONSTRAINT user_blocks_not_self CHECK ("blockerId" <> "blockedId")
);

-- One row per pair. Blocking twice is the same state as blocking once, so
-- the second attempt should be a no-op rather than a duplicate row.
CREATE UNIQUE INDEX IF NOT EXISTS user_blocks_pair_key
  ON public.user_blocks ("blockerId", "blockedId");

-- Answering "has anyone blocked me" is as common as "who have I blocked":
-- every message list filters in both directions.
CREATE INDEX IF NOT EXISTS user_blocks_blocked_idx
  ON public.user_blocks ("blockedId");

-- ── Reports ───────────────────────────────────────────────────────────

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'ReportCategory') THEN
    CREATE TYPE public."ReportCategory" AS ENUM (
      'SPAM', 'HARASSMENT', 'SEXUAL_CONTENT', 'HATE_SPEECH',
      'VIOLENCE_OR_THREAT', 'SCAM_OR_FRAUD', 'IMPERSONATION', 'OTHER'
    );
  END IF;

  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'ReportStatus') THEN
    CREATE TYPE public."ReportStatus" AS ENUM (
      'OPEN', 'REVIEWING', 'ACTIONED', 'DISMISSED'
    );
  END IF;
END $$;

CREATE TABLE IF NOT EXISTS public.content_reports (
  id               uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  "reporterId"     uuid NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  "reportedUserId" uuid NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,

  -- Nullable: a report can be about a person's conduct generally rather
  -- than one message. ON DELETE SET NULL, because a sender deleting the
  -- message must not delete the complaint about it.
  "messageId"      uuid REFERENCES public.messages(id) ON DELETE SET NULL,
  "conversationId" uuid REFERENCES public.conversations(id) ON DELETE SET NULL,
  "gymId"          uuid REFERENCES public.gyms(id) ON DELETE SET NULL,

  category public."ReportCategory" NOT NULL,

  -- What the reporter saw and what they say about it. The server cannot
  -- read the ciphertext, so this is the only account of the content a
  -- reviewer will ever have.
  details  varchar(2000) NOT NULL,

  status       public."ReportStatus" NOT NULL DEFAULT 'OPEN',
  "reviewedById" uuid REFERENCES public.admin_staff(id) ON DELETE SET NULL,
  "reviewedAt"   timestamp(3),
  "actionTaken"  varchar(500),

  "createdAt" timestamp(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

  CONSTRAINT content_reports_not_self CHECK ("reporterId" <> "reportedUserId")
);

-- The review queue: oldest open first, which is the order a desk works in.
CREATE INDEX IF NOT EXISTS content_reports_status_idx
  ON public.content_reports (status, "createdAt");

-- "Show me everything reported about this person" is the question that
-- decides whether one complaint is a pattern.
CREATE INDEX IF NOT EXISTS content_reports_reported_idx
  ON public.content_reports ("reportedUserId");

-- One report per person per message. Re-reporting the same message is not
-- more evidence, and a queue padded with duplicates is a queue nobody
-- finishes. A report with no message id is not covered -- those are about
-- conduct, and a second one may carry genuinely new information.
CREATE UNIQUE INDEX IF NOT EXISTS content_reports_one_per_message
  ON public.content_reports ("reporterId", "messageId")
  WHERE "messageId" IS NOT NULL;

-- RLS, matching every other table here: on, with no policies, because the
-- Data API is not used and the right answer for who may read these over it
-- is nobody. The application connects as the table owner and bypasses it.
ALTER TABLE public.user_blocks ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.content_reports ENABLE ROW LEVEL SECURITY;
