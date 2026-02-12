# Pest ID Field Assistant

Multi-tenant field assistant for pest-control techs in Alberta multi-unit housing. The app provides guided evidence capture, assistive pest identification, jurisdiction-compliant IPM plans, and audit-ready service reports. v1 is offline-first and deterministic; ML is assistive only.

## Goals
- Fast field workflow for techs, even without signal
- Compliance-first treatment guidance (pack-driven, versioned)
- Multi-tenant isolation with audit trails
- Expandable to new jurisdictions via pack swaps

## Repo Structure
- `apps/mobile` - React Native mobile app (tech workflow)
- `apps/admin-web` - Next.js admin portal (tenant management)
- `packages/shared` - Shared types, utilities, and schemas
- `packages/packs/ab` - Alberta jurisdiction pack (versioned content)
- `supabase` - Supabase setup notes and SQL (RLS, schema, policies)
- `docs` - Product and technical docs
- `scripts` - One-off scripts and tooling

## Planned Stack
- Mobile: React Native (Expo)
- Admin: Next.js
- Backend: Supabase (Postgres + Auth + Storage + RLS)
- ML: Separate inference service (phase 2)

## Getting Started (Scaffold)
1) Clone and install tooling
2) Configure Supabase project
3) Start mobile and admin apps

Detailed instructions will be added as the app is implemented.

## Status
Scaffold only. No implementation yet.
