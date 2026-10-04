-- ROLLBACK for migration device_family_restructure (4 Oct 2026).
-- Restores the global library to its pre-restructure state from the bak_restruct_* tables.
-- Run in the Supabase SQL editor only if the restructure must be undone.
--
-- Notes:
-- 1. Deleting global rows SET NULLs the links held by project tables, so links are
--    captured first and restored after the re-insert (row ids are preserved by the backup).
-- 2. project_equipment rows that pointed at a merged type were re-pointed to the family
--    survivor during the restructure. This rollback leaves them on that survivor row
--    (which becomes the surviving old type again, e.g. SPK-1-IC). The link stays valid
--    and in the same family; the exact pre-merge row is not recorded.

begin;

create temp table t_pe_links as
  select id, global_equipment_id, global_product_id from project_equipment
  where global_equipment_id is not null or global_product_id is not null;
create temp table t_pp_links as
  select id, global_product_id from project_products where global_product_id is not null;

delete from global_equipment;
insert into global_equipment select * from bak_restruct_global_equipment;

delete from global_products;
insert into global_products select * from bak_restruct_global_products;

delete from global_room_template_items;
insert into global_room_template_items select * from bak_restruct_grt_items;

update project_equipment pe
  set global_equipment_id = t.global_equipment_id, global_product_id = t.global_product_id
  from t_pe_links t where t.id = pe.id;
update project_products pp
  set global_product_id = t.global_product_id
  from t_pp_links t where t.id = pp.id;

commit;
