# Flutter Sina Refactor Status

## Current Safe State
- Legacy app still exists:
  - lib/main.dart
  - lib/legacy/legacy_main.dart

- Modular app exists:
  - lib/main_modular.dart
  - lib/app/modular_app.dart

## Completed Modular Parts
- Language system
- Core helpers
- Models
- Mock data
- AppState
- Shared widgets
- Floating announcement
- Global background
- Global logo
- Student panel
- Professor panel
- Manager panel
- Super admin sina panel
- Education class management
- Add/remove student from class
- Past class reports with filters
- Student profile file with education, finance and discipline sections
- Maintenance mode
- Registration toggle
- Role-based services
- Role-based classes bottom nav

## Next Steps
1. Improve Admin sina permissions editor.
2. Add section/user locking model.
3. Add real manager-to-admin chat input.
4. Add better ticket/request system.
5. Gradually replace legacy main.dart with modular app when stable.
