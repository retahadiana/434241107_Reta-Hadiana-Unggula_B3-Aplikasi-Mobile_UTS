# Swagger Documentation

This folder contains the OpenAPI contract for the e-ticketing helpdesk project.

## Files

- [openapi.yaml](openapi.yaml)

## How to view it in Swagger UI

1. Open the Swagger Editor at https://editor.swagger.io.
2. Paste the contents of [openapi.yaml](openapi.yaml) or import the file.
3. Review the generated documentation and try the endpoints from the UI.

## Project fit

This OpenAPI document follows the current Flutter + Supabase feature set:

- authentication
- profile management
- ticket creation and detail viewing
- comments and tracking
- notification read state
- admin role assignment

If you later split the app into a dedicated backend service, keep this file as the source of truth for the mobile app contract.

## Notes about Supabase endpoints

- The specification uses Supabase REST (`/rest/v1`) as the primary server because the Flutter app talks directly to tables via PostgREST.
- Authentication endpoints in Supabase live under the `/auth/v1` path (example: `https://<project>.supabase.co/auth/v1`) — the `openapi.yaml` includes that server entry for clarity, but the `paths` in this spec use logical routes such as `/auth/login` and may need to be prefixed with `/auth/v1` when calling Supabase directly.
- Storage (file uploads) uses the Storage API under `/storage/v1` — when calling Supabase storage directly, use the storage base URL plus the bucket operations.