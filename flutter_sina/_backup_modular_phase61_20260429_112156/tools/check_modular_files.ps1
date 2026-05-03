Write-Host "Checking modular files..." -ForegroundColor Cyan

$files = @(
  "lib\models\auth\app_lang.dart",
  "lib\core\constants\app_texts.dart",
  "lib\models\auth\app_role.dart",
  "lib\models\permissions\permission_model.dart",
  "lib\state\app_state.dart"
)

foreach ($file in $files) {
  if (Test-Path $file) {
    Write-Host "OK: $file" -ForegroundColor Green
  } else {
    Write-Host "MISSING: $file" -ForegroundColor Red
  }
}

Write-Host ""
Write-Host "Run: flutter analyze" -ForegroundColor Yellow
