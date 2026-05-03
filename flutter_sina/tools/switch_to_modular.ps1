Write-Host "Switching Flutter Sina to Modular main..." -ForegroundColor Cyan

if (!(Test-Path "pubspec.yaml")) {
  Write-Host "ERROR: pubspec.yaml پیدا نشد. داخل ریشه پروژه نیستید." -ForegroundColor Red
  exit
}

if (!(Test-Path "lib\main.dart")) {
  Write-Host "ERROR: lib\main.dart پیدا نشد." -ForegroundColor Red
  exit
}

if (!(Test-Path "lib\main_modular.dart")) {
  Write-Host "ERROR: lib\main_modular.dart پیدا نشد." -ForegroundColor Red
  exit
}

if (!(Test-Path "lib\legacy\legacy_main.dart")) {
  Write-Host "ERROR: legacy_main.dart پیدا نشد. اول مطمئن شوید نسخه قدیمی آرشیو شده است." -ForegroundColor Red
  exit
}

$stamp = Get-Date -Format "yyyyMMdd_HHmmss"
New-Item -ItemType Directory -Force -Path "_backup_before_switch_$stamp" | Out-Null

Copy-Item "lib\main.dart" "_backup_before_switch_$stamp\main.dart" -Force
Copy-Item "lib\main_modular.dart" "_backup_before_switch_$stamp\main_modular.dart" -Force
Copy-Item "lib\legacy\legacy_main.dart" "_backup_before_switch_$stamp\legacy_main.dart" -Force

@"
import 'package:flutter/material.dart';
import 'app/modular_app.dart';

void main() {
  runApp(const ModularApp());
}
"@ | Set-Content -Encoding UTF8 "lib\main.dart"

Write-Host "DONE: lib/main.dart now runs ModularApp." -ForegroundColor Green
Write-Host "Backup created: _backup_before_switch_$stamp" -ForegroundColor Yellow
