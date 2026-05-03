Write-Host "Checking Flutter Sina project..." -ForegroundColor Cyan

if (!(Test-Path "pubspec.yaml")) {
  Write-Host "ERROR: pubspec.yaml پیدا نشد. داخل ریشه پروژه نیستید." -ForegroundColor Red
  exit
}

if (!(Test-Path "lib\main.dart")) {
  Write-Host "ERROR: lib\main.dart پیدا نشد." -ForegroundColor Red
  exit
}

if (!(Test-Path "lib\legacy\legacy_main.dart")) {
  Write-Host "WARNING: legacy_main.dart هنوز ساخته نشده است." -ForegroundColor Yellow
} else {
  Write-Host "OK: legacy_main.dart وجود دارد." -ForegroundColor Green
}

$requiredFolders = @(
  "lib\app",
  "lib\core",
  "lib\models",
  "lib\state",
  "lib\screens",
  "lib\widgets"
)

foreach ($folder in $requiredFolders) {
  if (Test-Path $folder) {
    Write-Host "OK: $folder" -ForegroundColor Green
  } else {
    Write-Host "MISSING: $folder" -ForegroundColor Red
  }
}

Write-Host ""
Write-Host "Running flutter analyze..." -ForegroundColor Cyan
flutter analyze
