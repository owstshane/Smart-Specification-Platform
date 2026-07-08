-- APPLIED 8 Jul 2026 as migration transactional_cr_reject_and_delete (kept for reference).
-- ---------------------------------------------------------------
-- Today rejectCR/deleteCR run 6-10 sequential REST calls from the browser. If the network
-- drops mid-sequence the project is left half-reverted (the CR is already marked rejected
-- but some stamps remain). These functions do the same work in ONE database transaction.
-- After applying, the app's rejectCR/deleteCR would each become a single RPC call:
--   supaFetch('POST','rpc/reject_cr',{p_cr_id:id})
--
-- Security: SECURITY INVOKER, so row level security still applies to the caller.

create or replace function public.reject_cr(p_cr_id uuid)
returns void
language plpgsql
security invoker
as $$
begin
  -- Additions under this CR were never baseline: delete them (children before parents).
  delete from public.equipment_instances where change_cr_id = p_cr_id and change_status = 'added';
  delete from public.project_equipment   where change_cr_id = p_cr_id and change_status = 'added';
  delete from public.rooms               where change_cr_id = p_cr_id and change_status = 'added';
  -- Everything else it touched reverts to baseline tracking.
  update public.equipment_instances set change_status = null, change_cr_id = null, change_cr_ref = null where change_cr_id = p_cr_id;
  update public.project_equipment   set change_status = null, change_cr_id = null, change_cr_ref = null where change_cr_id = p_cr_id;
  update public.rooms               set change_status = null, change_cr_id = null, change_cr_ref = null where change_cr_id = p_cr_id;
  -- Status last: if anything above fails the whole transaction rolls back and the CR stays open.
  update public.change_requests set status = 'rejected' where id = p_cr_id;
end;
$$;

create or replace function public.delete_cr(p_cr_id uuid)
returns void
language plpgsql
security invoker
as $$
declare
  v_status text;
begin
  select status into v_status from public.change_requests where id = p_cr_id;
  if v_status is null then
    return; -- already gone
  end if;
  if v_status in ('approved','closed') then
    -- Approved changes are part of the project: keep rows and badges, just unlink the id.
    update public.equipment_instances set change_cr_id = null where change_cr_id = p_cr_id;
    update public.project_equipment   set change_cr_id = null where change_cr_id = p_cr_id;
    update public.rooms               set change_cr_id = null where change_cr_id = p_cr_id;
  else
    -- Unapproved: same revert as reject_cr.
    delete from public.equipment_instances where change_cr_id = p_cr_id and change_status = 'added';
    delete from public.project_equipment   where change_cr_id = p_cr_id and change_status = 'added';
    delete from public.rooms               where change_cr_id = p_cr_id and change_status = 'added';
    update public.equipment_instances set change_status = null, change_cr_id = null, change_cr_ref = null where change_cr_id = p_cr_id;
    update public.project_equipment   set change_status = null, change_cr_id = null, change_cr_ref = null where change_cr_id = p_cr_id;
    update public.rooms               set change_status = null, change_cr_id = null, change_cr_ref = null where change_cr_id = p_cr_id;
  end if;
  -- cr_cost_items cascade via FK; change_log.cr_id is SET NULL via FK.
  delete from public.change_requests where id = p_cr_id;
end;
$$;
