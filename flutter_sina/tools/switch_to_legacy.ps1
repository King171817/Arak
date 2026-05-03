Write-Host "Switching Flutter Sina back to Legacy main..." -ForegroundColor Cyan

if (!(Test-Path "pubspec.yaml")) {
  Write-Host "ERROR: pubspec.yaml پیدا نشد. داخل ریشه پروژه نیستید." -ForegroundColor Red
  exit
}

if (!(Test-Path "lib\legacy\legacy_main.dart")) {
  Write-Host "ERROR: lib/legacy/legacy_main.dart پیدا نشد." -ForegroundColor Red
  exit
}

$stamp = Get-Date -Format "yyyyMMdd_HHmmss"
New-Item -ItemType Directory -Force -Path "_backup_before_legacy_restore_$stamp" | Out-Null

if (Test-Path "lib\main.dart") {
  Copy-Item "lib\main.dart" "_backup_before_legacy_restore_$stamp\main.dart" -Force
}

@"
import 'legacy/legacy_main.dart' as legacy;

void main() {
  legacy.main();
}
"@ | Set-Content -Encoding UTF8 "lib\main.dart"

Write-Host "DONE: lib/main.dart now runs legacy app." -ForegroundColor Green
Write-Host "Backup created: _backup_before_legacy_restore_$stamp" -ForegroundColor Yellow
