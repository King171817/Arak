Write-Host "Flutter Sina Important Files Check" -ForegroundColor Cyan
Write-Host ""

$files = @(
  "lib\main.dart",
  "lib\app\modular_app.dart",
  "lib\state\app_state.dart",
  "lib\services\app_services.dart",
  "lib\services\supabase_bootstrap.dart",
  "lib\config\supabase_config.dart",
  "lib\screens\auth\login_screen.dart",
  "lib\screens\student\student_shell.dart",
  "lib\screens\professor\professor_shell.dart",
  "lib\screens\manager\manager_shell.dart",
  "lib\screens\admin\admin_shell.dart",
  "lib\screens\tickets\tickets_screen.dart",
  "database\supabase_schema.sql",
  "database\supabase_seed.sql",
  "database\supabase_rls_dev.sql",
  "UI_TEST_CHECKLIST.md",
  "REFACTOR_STATUS.md"
)

foreach ($file in $files) {
  if (Test-Path $file) {
    Write-Host "OK: $file" -ForegroundColor Green
  } else {
    Write-Host "MISSING: $file" -ForegroundColor Red
  }
}

Write-Host ""
Write-Host "Running analyze..." -ForegroundColor Yellow

flutter analyze `
  lib\main.dart `
  lib\app `
  lib\models `
  lib\data `
  lib\core `
  lib\widgets `
  lib\state `
  lib\screens `
  lib\repositories `
  lib\services `
  lib\config
