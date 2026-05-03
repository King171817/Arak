$baseUrl = "http://localhost:3000"
$password = "Test123456"

$users = @(
  @{ username="sina"; email="sina@zigurat.com"; role="admin" },
  @{ username="admin1"; email="admin1@zigurat.com"; role="admin" },
  @{ username="admin2"; email="admin2@zigurat.com"; role="admin" },
  @{ username="admin3"; email="admin3@zigurat.com"; role="admin" },
  @{ username="admin4"; email="admin4@zigurat.com"; role="admin" },
  @{ username="admin"; email="admin@zigurat.com"; role="student" },
  @{ username="prof1"; email="prof1@zigurat.com"; role="professor" },
  @{ username="prof2"; email="prof2@zigurat.com"; role="professor" },
  @{ username="test_student"; email="test_student@zigurat.com"; role="student" }
)

$report = @()
$tokens = @{}

function Add-Report($test, $status, $details) {
  $script:report += [PSCustomObject]@{
    Test = $test
    Status = $status
    Details = $details
  }
}

Write-Host "`n===== LOGIN TESTS =====" -ForegroundColor Cyan

foreach ($u in $users) {
  try {
    $login = Invoke-RestMethod `
      -Uri "$baseUrl/auth/login" `
      -Method POST `
      -ContentType "application/json" `
      -Body (@{
        email = $u.email
        password = $password
      } | ConvertTo-Json)

    $tokens[$u.username] = $login.accessToken

    Add-Report "Login $($u.username)" "OK" "$($u.email) | expected role: $($u.role) | returned role: $($login.user.role)"
  } catch {
    Add-Report "Login $($u.username)" "FAILED" $_.Exception.Message
  }
}

Write-Host "`n===== ADMIN ACCESS TESTS =====" -ForegroundColor Cyan

foreach ($adminUser in @("sina","admin1","admin2","admin3","admin4")) {
  try {
    $res = Invoke-RestMethod `
      -Uri "$baseUrl/admin/users" `
      -Method GET `
      -Headers @{
        Authorization = "Bearer $($tokens[$adminUser])"
      }

    Add-Report "Admin users access: $adminUser" "OK" "Users count: $($res.data.Count)"
  } catch {
    Add-Report "Admin users access: $adminUser" "FAILED" $_.Exception.Message
  }
}

Write-Host "`n===== BLOCK NON-ADMIN TESTS =====" -ForegroundColor Cyan

foreach ($blockedUser in @("admin","test_student","prof1","prof2")) {
  try {
    Invoke-RestMethod `
      -Uri "$baseUrl/admin/users" `
      -Method GET `
      -Headers @{
        Authorization = "Bearer $($tokens[$blockedUser])"
      }

    Add-Report "Block admin access: $blockedUser" "FAILED" "User accessed /admin/users but should be blocked"
  } catch {
    Add-Report "Block admin access: $blockedUser" "OK" "Blocked correctly"
  }
}

Write-Host "`n===== STUDENT REQUEST WORKFLOW =====" -ForegroundColor Cyan

try {
  $createdRequest = Invoke-RestMethod `
    -Uri "$baseUrl/requests" `
    -Method POST `
    -ContentType "application/json" `
    -Headers @{
      Authorization = "Bearer $($tokens['test_student'])"
    } `
    -Body '{
      "type":"translation",
      "priority":"normal",
      "details":{
        "sourceLang":"fa",
        "targetLang":"en",
        "pageCount":2,
        "createdBy":"test_student"
      }
    }'

  $requestId = $createdRequest.data.id
  $requestNumber = $createdRequest.data.requestNumber

  Add-Report "Student create request" "OK" "$requestNumber"
} catch {
  Add-Report "Student create request" "FAILED" $_.Exception.Message
}

try {
  $studentRequests = Invoke-RestMethod `
    -Uri "$baseUrl/requests" `
    -Method GET `
    -Headers @{
      Authorization = "Bearer $($tokens['test_student'])"
    }

  Add-Report "Student get own requests" "OK" "Count: $($studentRequests.data.Count)"
} catch {
  Add-Report "Student get own requests" "FAILED" $_.Exception.Message
}

try {
  $adminRequests = Invoke-RestMethod `
    -Uri "$baseUrl/admin/requests" `
    -Method GET `
    -Headers @{
      Authorization = "Bearer $($tokens['sina'])"
    }

  Add-Report "Sina get all requests" "OK" "Count: $($adminRequests.data.Count)"
} catch {
  Add-Report "Sina get all requests" "FAILED" $_.Exception.Message
}

try {
  if ($requestId) {
    $updated = Invoke-RestMethod `
      -Uri "$baseUrl/admin/requests/$requestId/status" `
      -Method PUT `
      -ContentType "application/json" `
      -Headers @{
        Authorization = "Bearer $($tokens['sina'])"
      } `
      -Body '{
        "status":"in_progress"
      }'

    Add-Report "Sina update request status" "OK" "New status: $($updated.data.status)"
  } else {
    Add-Report "Sina update request status" "SKIPPED" "No request id"
  }
} catch {
  Add-Report "Sina update request status" "FAILED" $_.Exception.Message
}

try {
  $finalStudentRequests = Invoke-RestMethod `
    -Uri "$baseUrl/requests" `
    -Method GET `
    -Headers @{
      Authorization = "Bearer $($tokens['test_student'])"
    }

  $checked = $finalStudentRequests.data | Where-Object { $_.id -eq $requestId }

  if ($checked) {
    Add-Report "Student sees updated status" "OK" "$($checked.requestNumber) = $($checked.status)"
  } else {
    Add-Report "Student sees updated status" "FAILED" "Request not found"
  }
} catch {
  Add-Report "Student sees updated status" "FAILED" $_.Exception.Message
}

Write-Host "`n===============================" -ForegroundColor Green
Write-Host " FINAL BACKEND TEST REPORT" -ForegroundColor Green
Write-Host "===============================`n" -ForegroundColor Green

$report | Format-Table -AutoSize

Write-Host "`n===============================" -ForegroundColor Cyan
Write-Host " FINAL USERS LIST" -ForegroundColor Cyan
Write-Host "===============================`n" -ForegroundColor Cyan

$finalUsers = Invoke-RestMethod `
  -Uri "$baseUrl/admin/users" `
  -Method GET `
  -Headers @{
    Authorization = "Bearer $($tokens['sina'])"
  }

$finalUsers.data | Format-Table email,fullName,role,isActive,countryOfOrigin -AutoSize

Write-Host "`n===============================" -ForegroundColor Cyan
Write-Host " FINAL REQUESTS LIST" -ForegroundColor Cyan
Write-Host "===============================`n" -ForegroundColor Cyan

$finalRequests = Invoke-RestMethod `
  -Uri "$baseUrl/admin/requests" `
  -Method GET `
  -Headers @{
    Authorization = "Bearer $($tokens['sina'])"
  }

$finalRequests.data | Format-Table requestNumber,type,status,priority,userId -AutoSize
