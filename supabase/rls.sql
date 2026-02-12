create or replace function public.is_tenant_member(_tenant_id uuid)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1
    from tenant_memberships tm
    where tm.tenant_id = _tenant_id
      and tm.user_id = auth.uid()
  );
$$;

create or replace function public.is_tenant_admin(_tenant_id uuid)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1
    from tenant_memberships tm
    where tm.tenant_id = _tenant_id
      and tm.user_id = auth.uid()
      and tm.role = 'admin'
  );
$$;

alter table tenants enable row level security;
alter table profiles enable row level security;
alter table tenant_memberships enable row level security;
alter table sites enable row level security;
alter table units enable row level security;
alter table visits enable row level security;
alter table evidence enable row level security;
alter table pest_catalog enable row level security;
alter table packs_jurisdiction enable row level security;
alter table packs_tenant_sop enable row level security;
alter table visit_identifications enable row level security;
alter table treatment_plans enable row level security;
alter table reports enable row level security;
alter table audit_log enable row level security;

create policy "profiles_select_self" on profiles
for select
using (user_id = auth.uid());

create policy "profiles_insert_self" on profiles
for insert
with check (user_id = auth.uid());

create policy "profiles_update_self" on profiles
for update
using (user_id = auth.uid())
with check (user_id = auth.uid());

create policy "tenants_select_member" on tenants
for select
using (is_tenant_member(id));

create policy "tenant_memberships_select_member" on tenant_memberships
for select
using (is_tenant_member(tenant_id));

create policy "tenant_memberships_insert_admin" on tenant_memberships
for insert
with check (is_tenant_admin(tenant_id));

create policy "tenant_memberships_update_admin" on tenant_memberships
for update
using (is_tenant_admin(tenant_id))
with check (is_tenant_admin(tenant_id));

create policy "tenant_memberships_delete_admin" on tenant_memberships
for delete
using (is_tenant_admin(tenant_id));

create policy "sites_select_member" on sites
for select
using (is_tenant_member(tenant_id));

create policy "sites_insert_member" on sites
for insert
with check (is_tenant_member(tenant_id));

create policy "sites_update_member" on sites
for update
using (is_tenant_member(tenant_id))
with check (is_tenant_member(tenant_id));

create policy "sites_delete_member" on sites
for delete
using (is_tenant_member(tenant_id));

create policy "units_select_member" on units
for select
using (is_tenant_member(tenant_id));

create policy "units_insert_member" on units
for insert
with check (is_tenant_member(tenant_id));

create policy "units_update_member" on units
for update
using (is_tenant_member(tenant_id))
with check (is_tenant_member(tenant_id));

create policy "units_delete_member" on units
for delete
using (is_tenant_member(tenant_id));

create policy "visits_select_member" on visits
for select
using (is_tenant_member(tenant_id));

create policy "visits_insert_member" on visits
for insert
with check (is_tenant_member(tenant_id));

create policy "visits_update_member" on visits
for update
using (is_tenant_member(tenant_id))
with check (is_tenant_member(tenant_id));

create policy "visits_delete_member" on visits
for delete
using (is_tenant_member(tenant_id));

create policy "evidence_select_member" on evidence
for select
using (is_tenant_member(tenant_id));

create policy "evidence_insert_member" on evidence
for insert
with check (is_tenant_member(tenant_id));

create policy "evidence_update_member" on evidence
for update
using (is_tenant_member(tenant_id))
with check (is_tenant_member(tenant_id));

create policy "evidence_delete_member" on evidence
for delete
using (is_tenant_member(tenant_id));

create policy "visit_identifications_select_member" on visit_identifications
for select
using (is_tenant_member(tenant_id));

create policy "visit_identifications_insert_member" on visit_identifications
for insert
with check (is_tenant_member(tenant_id));

create policy "visit_identifications_update_member" on visit_identifications
for update
using (is_tenant_member(tenant_id))
with check (is_tenant_member(tenant_id));

create policy "visit_identifications_delete_member" on visit_identifications
for delete
using (is_tenant_member(tenant_id));

create policy "treatment_plans_select_member" on treatment_plans
for select
using (is_tenant_member(tenant_id));

create policy "treatment_plans_insert_member" on treatment_plans
for insert
with check (is_tenant_member(tenant_id));

create policy "treatment_plans_update_member" on treatment_plans
for update
using (is_tenant_member(tenant_id))
with check (is_tenant_member(tenant_id));

create policy "treatment_plans_delete_member" on treatment_plans
for delete
using (is_tenant_member(tenant_id));

create policy "reports_select_member" on reports
for select
using (is_tenant_member(tenant_id));

create policy "reports_insert_member" on reports
for insert
with check (is_tenant_member(tenant_id));

create policy "reports_update_draft_only" on reports
for update
using (is_tenant_member(tenant_id) and status = 'draft')
with check (is_tenant_member(tenant_id) and status = 'draft');

create policy "reports_delete_member" on reports
for delete
using (is_tenant_member(tenant_id));

create policy "audit_log_select_admin" on audit_log
for select
using (is_tenant_admin(tenant_id));

create policy "audit_log_insert_member" on audit_log
for insert
with check (is_tenant_member(tenant_id));

create policy "packs_tenant_sop_select_member" on packs_tenant_sop
for select
using (is_tenant_member(tenant_id));

create policy "packs_tenant_sop_insert_admin" on packs_tenant_sop
for insert
with check (is_tenant_admin(tenant_id));

create policy "packs_tenant_sop_update_admin" on packs_tenant_sop
for update
using (is_tenant_admin(tenant_id))
with check (is_tenant_admin(tenant_id));

create policy "packs_tenant_sop_delete_admin" on packs_tenant_sop
for delete
using (is_tenant_admin(tenant_id));

create policy "pest_catalog_select_authenticated" on pest_catalog
for select
to authenticated
using (true);

create policy "packs_jurisdiction_select_authenticated" on packs_jurisdiction
for select
to authenticated
using (true);

create policy "pest_catalog_write_service_role" on pest_catalog
for insert
to service_role
with check (true);

create policy "packs_jurisdiction_write_service_role" on packs_jurisdiction
for insert
to service_role
with check (true);

create policy "pest_catalog_update_service_role" on pest_catalog
for update
to service_role
using (true)
with check (true);

create policy "packs_jurisdiction_update_service_role" on packs_jurisdiction
for update
to service_role
using (true)
with check (true);

create policy "pest_catalog_delete_service_role" on pest_catalog
for delete
to service_role
using (true);

create policy "packs_jurisdiction_delete_service_role" on packs_jurisdiction
for delete
to service_role
using (true);
