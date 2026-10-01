-- Pin reject_mutation's search_path (Supabase advisor 0011,
-- function_search_path_mutable).
--
-- The function is the guard that makes audit_logs, consent_records and
-- security_events append-only. It references no table or function -- it
-- only raises -- so an empty search_path changes nothing about what it does.
-- What it removes is the possibility of a caller-controlled search_path
-- resolving a name inside the function to an object of their choosing,
-- which is the general reason the advisor flags any function without one.
ALTER FUNCTION public.reject_mutation() SET search_path = '';
