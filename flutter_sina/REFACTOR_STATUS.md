# Flutter Sina Refactor Status

## Current Main
- lib/main.dart now runs the modular app.
- Legacy app is preserved in:
  - lib/legacy/legacy_main.dart

## Modular Completed
- Modular folder structure
- Language system
- Role-based dashboards
- Student panel
- Professor panel
- Manager panel
- Super admin sina panel
- Floating announcement
- Global logo/background
- Maintenance mode
- Section/user/unit/role locking
- Tickets/requests with tracking code
- Education class management
- Student profile file
- Past class reports with filters
- Mock repositories
- Repository interfaces
- Supabase package added
- Supabase bootstrap prepared
- Supabase repository skeletons
- Supabase SQL schema
- Supabase seed SQL
- Supabase dev RLS SQL

## Important Test Accounts
- Student: admin / 1234
- Professor: prof1 / 1234
- International Manager: admin1 / 1234
- Education Manager: admin2 / 1234
- Student Services Manager: admin3 / 1234
- Consular Manager: admin4 / 1234
- Super Admin: sina / 1234
- Education Officer: edu_officer1 / 1234

## Next Recommended Steps
1. Run the app and test all roles.
2. If Supabase is needed, run database SQL files in this order:
   - database/supabase_schema.sql
   - database/supabase_rls_dev.sql
   - database/supabase_seed.sql
3. Put Supabase URL and anon key in:
   - lib/config/supabase_config.dart
4. Replace development RLS policies before production.
