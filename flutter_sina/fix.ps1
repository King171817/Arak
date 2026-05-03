$path = "D:\fathi\amir\z2\flutter_sina\lib\main.dart"
$backup = "D:\fathi\amir\z2\flutter_sina\lib\main_backup.dart"

Copy-Item $path $backup -Force

$text = Get-Content $path -Raw -Encoding UTF8

# حذف const اشتباه
$text = $text -replace "const ProfessorLiveClassRoomScreen", "ProfessorLiveClassRoomScreen"

# اصلاح SuperAdminPanel
$text = $text -replace "return SuperAdminPanel\(\);", "return const HomeScreen();"
$text = $text -replace "return const SuperAdminPanel\(\);", "return const HomeScreen();"

# اصلاح constructor خراب
$text = $text -replace "const ProfessorClassScreen\(\{super.key, required this.classModel\}\);", "const ProfessorLiveClassRoomScreen({Key? key, required this.classModel}) : super(key: key);"

# اصلاح font برای مشکل وب
$text = $text -replace "useMaterial3:\s*true,", "useMaterial3: true, fontFamily: 'Arial',"

Set-Content $path $text -Encoding UTF8

Write-Host "Fix applied successfully"
