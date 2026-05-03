Write-Host "Flutter Sina Modular Login Test" -ForegroundColor Cyan
Write-Host ""
Write-Host "Test accounts:" -ForegroundColor Yellow
Write-Host "Student:          admin / 1234"
Write-Host "Professor:        prof1 / 1234"
Write-Host "International:    admin1 / 1234"
Write-Host "Education:        admin2 / 1234"
Write-Host "Student Services: admin3 / 1234"
Write-Host "Consular:         admin4 / 1234"
Write-Host "Super Admin:      sina / 1234"
Write-Host "Education Officer: edu_officer1 / 1234"
Write-Host ""
Write-Host "Running modular app..." -ForegroundColor Green

flutter run -d chrome -t lib\main_modular.dart
