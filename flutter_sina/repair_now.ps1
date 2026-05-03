$path = "D:\fathi\amir\z2\flutter_sina\lib\main.dart"
$text = Get-Content $path -Raw -Encoding UTF8

$text = $text.Replace("return const SuperAdminPanel();", "return SuperAdminPanel();")

$text = $text.Replace(
"const ProfessorLiveClassRoomScreen({super.key, required this.classModel});",
"const ProfessorClassScreen({super.key, required this.classModel});"
)

$start = $text.IndexOf("Widget _control(")
if ($start -ge 0) {
  $end = $text.IndexOf("Widget _", $start + 20)
  if ($end -gt $start) {
    $replacement = @'
Widget _control(AppLang lang, LiveClassSession s, List<StudentInClassModel> students) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text("Class controls repaired"),
          ),
        ),
      ],
    );
  }

  
'@
    $text = $text.Substring(0, $start) + $replacement + $text.Substring($end)
  }
}

Set-Content $path $text -Encoding UTF8
Write-Host "main.dart repaired successfully."
