# Run this script from the root of your Flutter project.
if (!(Test-Path "pubspec.yaml")) {
  Write-Host "ERROR: Run this from the Flutter project root." -ForegroundColor Red
  exit
}

$stamp = Get-Date -Format "yyyyMMdd_HHmmss"
New-Item -ItemType Directory -Force -Path "_backup_before_modular_$stamp" | Out-Null
Copy-Item -Path "lib" -Destination "_backup_before_modular_$stamp\lib" -Recurse -Force
Copy-Item -Path "pubspec.yaml" -Destination "_backup_before_modular_$stamp\pubspec.yaml" -Force

Write-Host "Backup created: _backup_before_modular_$stamp" -ForegroundColor Green
Write-Host "Now copy the lib folder from this ZIP into your project root." -ForegroundColor Yellow
