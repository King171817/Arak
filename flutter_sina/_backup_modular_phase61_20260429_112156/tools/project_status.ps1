Write-Host "Checking Flutter Sina project status..." -ForegroundColor Cyan

if (!(Test-Path "pubspec.yaml")) {
  Write-Host "ERROR: pubspec.yaml پیدا نشد. داخل ریشه پروژه نیستید." -ForegroundColor Red
  exit
}

Write-Host ""
Write-Host "Checking important files..." -ForegroundColor Yellow

$files = @(
  "lib\main.dart",
  "lib\main_modular.dart",
  "lib\legacy\legacy_main.dart",
  "lib\app\modular_app.dart",
  "lib\state\app_state.dart",
  "tools\run_legacy.ps1",
  "tools\run_modular.ps1",
  "tools\analyze_modular.ps1"
)

foreach ($file in $files) {
  if (Test-Path $file) {
    Write-Host "OK: $file" -ForegroundColor Green
  } else {
    Write-Host "MISSING: $file" -ForegroundColor Red
  }
}

Write-Host ""
Write-Host "Legacy line count:" -ForegroundColor Yellow
if (Test-Path "lib\legacy\legacy_main.dart") {
  (Get-Content "lib\legacy\legacy_main.dart").Count
}

Write-Host ""
Write-Host "Modular analyze:" -ForegroundColor Yellow

flutter analyze `
  lib\models `
  lib\data `
  lib\core `
  lib\widgets `
  lib\state `
  lib\screens\student `
  lib\screens\auth `
  lib\screens\professor `
  lib\screens\manager `
  lib\screens\admin `
  lib\app `
  lib\main_modular.dart
