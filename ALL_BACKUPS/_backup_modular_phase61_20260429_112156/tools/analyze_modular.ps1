Write-Host "Analyzing Flutter Sina Modular App..." -ForegroundColor Cyan

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
