-- DB-level append-only enforcement for audit_logs, consent_records and
-- security_events.
--
-- Hand-written, like every migration here: this database also holds the
-- legacy v1 tables, so `migrate diff` would propose dropping all of them.
--
-- ## What this closes
--
-- audit.service.ts used to say, correctly: "APPEND-ONLY IS A PROPERTY OF
-- THIS CODE, NOT OF THE DATABASE... the application connects as the owner
-- of the table and can rewrite or empty it at will." Checked live before
-- writing this: the app's role (postgres) is NOT a Postgres superuser --
-- rolsuper is false, it only carries rolbypassrls -- and it owns all three
-- tables. Application code never calls UPDATE, DELETE or TRUNCATE against
-- any of them (grepped across src/ before writing this migration); every
-- write is an INSERT from AuditService, ConsentService or
-- SecurityEventService.
--
-- These triggers turn "nothing does" into "nothing can" for the ordinary
-- path: any UPDATE, DELETE or TRUNCATE against these three tables is
-- rejected, regardless of which role issues it, including the table
-- owner. Because the app's role is not a superuser, it cannot silently
-- work around this with `SET session_replication_role = replica` --
-- that command itself requires superuser on this database. The only way
-- to remove this protection is an explicit `ALTER TABLE ... DISABLE
-- TRIGGER` or `DROP TRIGGER`, which is a distinct, conspicuous statement
-- in its own right rather than an ordinary write silently rewriting
-- history.
--
-- ## What this does NOT close
--
-- A role that owns these tables can still run ALTER TABLE to disable or
-- drop the trigger before writing. Making even that impossible needs a
-- second, genuinely restricted role (INSERT + SELECT only, no ALTER, no
-- ownership) that the application would have to connect as for these
-- three tables specifically -- a bigger, separate piece of infrastructure
-- work, not a trigger. This migration is the practical middle ground: it
-- stops accidental tampering (a future bug, a careless migration, a
-- compromised credential riding the existing connection) without
-- requiring a second database role and a second connection string today.
--
-- ## One real side effect
--
-- audit_logs.actorId has ON DELETE SET NULL against users(id). No code
-- path hard-deletes a User row -- accounts are anonymised, never removed,
-- by deliberate design (see account-deletion.service.ts). If that were
-- ever to change, deleting a user with audit history would now fail
-- rather than silently rewriting the actor reference on their audit
-- rows. That failure is the correct behaviour, not a bug to work around.

CREATE OR REPLACE FUNCTION public.reject_mutation()
RETURNS TRIGGER AS $$
BEGIN
  RAISE EXCEPTION
    'Table "%" is append-only: % is not permitted. Insert new rows instead of changing existing ones.',
    TG_TABLE_NAME, TG_OP
    USING ERRCODE = 'insufficient_privilege';
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION public.reject_mutation() IS
  'Blocks UPDATE/DELETE/TRUNCATE on append-only tables. See migration 20260921_append_only_triggers.';

DO $$
DECLARE
  t text;
BEGIN
  FOREACH t IN ARRAY ARRAY['audit_logs', 'consent_records', 'security_events']
  LOOP
    EXECUTE format(
      'DROP TRIGGER IF EXISTS %I_no_update_delete ON public.%I', t, t
    );
    EXECUTE format(
      'CREATE TRIGGER %I_no_update_delete
         BEFORE UPDATE OR DELETE ON public.%I
         FOR EACH ROW EXECUTE FUNCTION public.reject_mutation()',
      t, t
    );

    EXECUTE format(
      'DROP TRIGGER IF EXISTS %I_no_truncate ON public.%I', t, t
    );
    EXECUTE format(
      'CREATE TRIGGER %I_no_truncate
         BEFORE TRUNCATE ON public.%I
         FOR EACH STATEMENT EXECUTE FUNCTION public.reject_mutation()',
      t, t
    );
  END LOOP;
END $$;
