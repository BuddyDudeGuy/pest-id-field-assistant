create extension if not exists pgcrypto;

create table if not exists tenants (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  created_at timestamptz not null default now()
);

create table if not exists profiles (
  user_id uuid primary key references auth.users(id) on delete cascade,
  display_name text,
  created_at timestamptz not null default now()
);

create table if not exists tenant_memberships (
  tenant_id uuid not null references tenants(id) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,
  role text not null check (role in ('admin', 'tech', 'manager')),
  created_at timestamptz not null default now(),
  primary key (tenant_id, user_id)
);

create table if not exists sites (
  id uuid primary key default gen_random_uuid(),
  tenant_id uuid not null references tenants(id) on delete cascade,
  name text not null,
  address_text text,
  created_at timestamptz not null default now()
);

create table if not exists units (
  id uuid primary key default gen_random_uuid(),
  tenant_id uuid not null references tenants(id) on delete cascade,
  site_id uuid not null references sites(id) on delete cascade,
  label text not null,
  unit_type text not null check (unit_type in ('unit', 'common_area', 'mechanical')),
  created_at timestamptz not null default now()
);

create table if not exists visits (
  id uuid primary key default gen_random_uuid(),
  tenant_id uuid not null references tenants(id) on delete cascade,
  site_id uuid not null references sites(id) on delete cascade,
  unit_id uuid references units(id) on delete set null,
  status text not null check (status in ('draft', 'synced', 'closed')),
  started_at timestamptz,
  ended_at timestamptz,
  created_by uuid not null references auth.users(id) on delete restrict,
  created_at timestamptz not null default now()
);

create table if not exists evidence (
  id uuid primary key default gen_random_uuid(),
  tenant_id uuid not null references tenants(id) on delete cascade,
  visit_id uuid not null references visits(id) on delete cascade,
  kind text not null check (kind in ('photo', 'note')),
  storage_path text,
  note text,
  captured_at timestamptz,
  created_by uuid not null references auth.users(id) on delete restrict,
  created_at timestamptz not null default now()
);

create table if not exists pest_catalog (
  id text primary key,
  display_name text not null,
  category text not null check (category in ('insect', 'rodent', 'other')),
  active boolean not null default true
);

create table if not exists packs_jurisdiction (
  id uuid primary key default gen_random_uuid(),
  jurisdiction text not null,
  version text not null,
  status text not null check (status in ('draft', 'published')),
  pack jsonb not null,
  published_at timestamptz,
  created_at timestamptz not null default now()
);

create table if not exists packs_tenant_sop (
  id uuid primary key default gen_random_uuid(),
  tenant_id uuid not null references tenants(id) on delete cascade,
  version int not null,
  status text not null check (status in ('draft', 'published')),
  pack jsonb not null,
  published_at timestamptz,
  created_by uuid not null references auth.users(id) on delete restrict,
  created_at timestamptz not null default now(),
  unique (tenant_id, version)
);

create table if not exists visit_identifications (
  visit_id uuid primary key references visits(id) on delete cascade,
  tenant_id uuid not null references tenants(id) on delete cascade,
  final_pest_id text references pest_catalog(id) on delete set null,
  final_notes text,
  created_at timestamptz not null default now()
);

create table if not exists treatment_plans (
  id uuid primary key default gen_random_uuid(),
  tenant_id uuid not null references tenants(id) on delete cascade,
  visit_id uuid not null references visits(id) on delete cascade,
  jurisdiction_pack_version text not null,
  tenant_sop_version int,
  plan jsonb not null,
  created_at timestamptz not null default now()
);

create table if not exists reports (
  id uuid primary key default gen_random_uuid(),
  tenant_id uuid not null references tenants(id) on delete cascade,
  visit_id uuid not null references visits(id) on delete cascade,
  status text not null check (status in ('draft', 'final')),
  snapshot jsonb not null,
  finalized_at timestamptz,
  finalized_by uuid references auth.users(id) on delete set null,
  pdf_storage_path text,
  created_at timestamptz not null default now()
);

create table if not exists audit_log (
  id uuid primary key default gen_random_uuid(),
  tenant_id uuid references tenants(id) on delete set null,
  actor_user_id uuid references auth.users(id) on delete set null,
  action text not null,
  entity_type text not null,
  entity_id text not null,
  payload jsonb,
  created_at timestamptz not null default now()
);

create index if not exists idx_sites_tenant_id on sites(tenant_id);
create index if not exists idx_units_tenant_id on units(tenant_id);
create index if not exists idx_visits_tenant_id on visits(tenant_id);
create index if not exists idx_evidence_tenant_id on evidence(tenant_id);
create index if not exists idx_reports_tenant_id on reports(tenant_id);
create index if not exists idx_treatment_plans_tenant_id on treatment_plans(tenant_id);
create index if not exists idx_visit_identifications_tenant_id on visit_identifications(tenant_id);
