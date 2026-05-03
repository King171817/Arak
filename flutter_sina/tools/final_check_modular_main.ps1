Write-Host "Final checking Flutter Sina Modular Main..." -ForegroundColor Cyan

if (!(Test-Path "pubspec.yaml")) {
  Write-Host "ERROR: pubspec.yaml پیدا نشد." -ForegroundColor Red
  exit
}

if (!(Test-Path "lib\main.dart")) {
  Write-Host "ERROR: lib/main.dart پیدا نشد." -ForegroundColor Red
  exit
}

Write-Host ""
Write-Host "Running analyze for modular main..." -ForegroundColor Yellow

flutter analyze `
  lib\main.dart `
  lib\app `
  lib\models `
  lib\data `
  lib\core `
  lib\widgets `
  lib\state `
  lib\screens

Write-Host ""
Write-Host "If analyze has no errors, run:" -ForegroundColor Green
Write-Host "powershell -ExecutionPolicy Bypass -File tools\run_main.ps1"
