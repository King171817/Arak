Write-Host "Flutter Sina Final Run Check" -ForegroundColor Cyan
Write-Host ""

if (!(Test-Path "pubspec.yaml")) {
  Write-Host "ERROR: pubspec.yaml پیدا نشد." -ForegroundColor Red
  exit
}

Write-Host "Running flutter analyze..." -ForegroundColor Yellow

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

if ($LASTEXITCODE -ne 0) {
  Write-Host ""
  Write-Host "ERROR: Analyze failed. Fix errors before running." -ForegroundColor Red
  exit
}

Write-Host ""
Write-Host "Analyze passed. Running app on Chrome..." -ForegroundColor Green
flutter run -d chrome
