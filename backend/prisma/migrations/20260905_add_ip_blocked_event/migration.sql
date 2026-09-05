-- Record the moment an IP is actually blocked, not just observed.
--
-- Detection already wrote SecurityEvent rows for injection signatures, OTP
-- farming and brute force, and then nothing acted on them: the service
-- exposed a countRecent() helper for "the throttling logic that decides
-- whether an IP has earned a temporary block", and no such logic existed --
-- the method was called from nowhere in the codebase.
--
-- A block is itself a security-relevant action taken against a caller, so it
-- belongs in the same log as the events that triggered it. Without its own
-- type an operator reading the log sees the attack and cannot tell whether
-- anything was done about it.
--
-- Hand-written, like every migration here: this database also holds the
-- legacy v1 tables, so `migrate diff` would propose dropping all of them.

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_enum
    WHERE enumlabel = 'IP_BLOCKED'
      AND enumtypid = 'public."SecurityEventType"'::regtype
  ) THEN
    ALTER TYPE public."SecurityEventType" ADD VALUE 'IP_BLOCKED';
  END IF;
END
$$;
