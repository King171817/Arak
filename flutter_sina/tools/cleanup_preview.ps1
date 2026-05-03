Write-Host "Flutter Sina Cleanup Preview" -ForegroundColor Cyan
Write-Host ""
Write-Host "This script only shows backup/archive folders. It does NOT delete anything." -ForegroundColor Yellow
Write-Host ""

$patterns = @(
  "_backup*",
  "_old_*",
  "_backup_modular*",
  "_backup_phase*",
  "_backup_before*"
)

foreach ($pattern in $patterns) {
  Write-Host "Searching: $pattern" -ForegroundColor Yellow
  Get-ChildItem -Directory -Filter $pattern -ErrorAction SilentlyContinue | ForEach-Object {
    Write-Host "  $($_.Name)" -ForegroundColor Gray
  }
}

Write-Host ""
Write-Host "If you want to delete a specific folder, use:" -ForegroundColor Green
Write-Host "Remove-Item 'folder_name' -Recurse -Force"
