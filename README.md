# Ticketing Helpdesk Mobile

Flutter mobile app for E-Ticketing Helpdesk with role-based access:
- User: create ticket, view own tickets, comment, track status.
- Helpdesk/Admin: view all tickets, update status, assign ticket, comment.

## Backend Integration (Supabase)

This app is connected to real Supabase API (Auth + Postgres + Storage).

## API Documentation (Swagger / OpenAPI)

The current repository uses Supabase directly from the Flutter client, so there is no separate HTTP backend service in the source tree yet. To document the API contract that matches this e-ticketing app, use the OpenAPI spec in:

- `docs/api/openapi.yaml`

That spec documents the logical API surface for:

- authentication
- profile management
- ticket CRUD
- comments and tracking
- notifications
- admin role assignment

To preview it in Swagger UI, open the file in the Swagger Editor or import it into any Swagger/OpenAPI viewer.

### 1. Prepare database
Run SQL from:
- `supabase/srs_backend_setup.sql`

This script creates:
- `profiles`
- `tickets`
- `ticket_comments`
- `ticket_tracking`
- `ticket_notifications`

It also enables Row Level Security (RLS) with role-based policies.

### 2. Configure app environment
Run app with `dart-define` values:

```bash
flutter run \
  --dart-define=SUPABASE_URL=https://YOUR_PROJECT.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=YOUR_ANON_KEY
```

If not provided, app uses fallback values in `lib/main.dart`.

## Role Permissions

Client and endpoint guard are both enforced:
- Client/UI guard: `lib/core/permissions.dart`
- Endpoint guard: Supabase RLS policies in `supabase/srs_backend_setup.sql`

### Admin provisioning

Admin can provision role for registered users from Profile page:
- Open `Provisioning Role User`
- Select target role (`User`, `Helpdesk`, `Admin`)
- Change is executed via secure RPC: `assign_user_role`

Only Admin can execute this action (UI + policy + RPC validation).

## SRS Traceability

Traceability matrix is available at:
- `docs/srs_traceability_matrix.md`

It maps SRS requirement IDs to:
- screen/feature
- endpoint/table
- source file

## Main Application Structure

- `lib/core/`: app controller, permissions, backend state
- `lib/services/`: auth/profile/ticket API integration
- `lib/models/`: profile and ticket domain entities
- `lib/features/`: auth, home shell, tickets UI

## Test

```bash
flutter test
```

Permission guard coverage is included in:
- `test/permission_guard_test.dart`
