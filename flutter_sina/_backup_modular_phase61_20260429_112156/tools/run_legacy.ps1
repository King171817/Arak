Write-Host "Running Flutter Sina Legacy App..." -ForegroundColor Cyan

if (!(Test-Path "pubspec.yaml")) {
  Write-Host "ERROR: pubspec.yaml پیدا نشد. داخل ریشه پروژه نیستید." -ForegroundColor Red
  exit
}

if (!(Test-Path "lib\main.dart")) {
  Write-Host "ERROR: lib\main.dart پیدا نشد." -ForegroundColor Red
  exit
}

flutter run -d chrome -t lib\main.dart
