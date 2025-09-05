param(
  [string]$Date = (Get-Date).ToString('yyyy-MM-dd')
)

$repoRoot = Split-Path -Parent $PSScriptRoot
Set-Location $repoRoot

# Chinese DOW: 周日/周一/…（周=U+5468，日=U+65E5，一=U+4E00，二=U+4E8C，三=U+4E09，四=U+56DB，五=U+4E94，六=U+516D）
$zh = @{
  Sunday    = "`u5468`u65e5"
  Monday    = "`u5468`u4e00"
  Tuesday   = "`u5468`u4e8c"
  Wednesday = "`u5468`u4e09"
  Thursday  = "`u5468`u56db"
  Friday    = "`u5468`u4e94"
  Saturday  = "`u5468`u516d"
}
# Japanese DOW: 日曜日/月曜日/…（曜=U+66DC，月=U+6708，火=U+706B，水=U+6C34，木=U+6728，金=U+91D1，土=U+571F）
$jp = @{
  Sunday    = "`u65e5`u66dc`u65e5"
  Monday    = "`u6708`u66dc`u65e5"
  Tuesday   = "`u706b`u66dc`u65e5"
  Wednesday = "`u6c34`u66dc`u65e5"
  Thursday  = "`u6728`u66dc`u65e5"
  Friday    = "`u91d1`u66dc`u65e5"
  Saturday  = "`u571f`u66dc`u65e5"
}

$dt    = Get-Date $Date
$yyyy  = $dt.ToString('yyyy')
$mm    = $dt.ToString('MM')
$dd    = $dt.ToString('dd')
$ymd   = $dt.ToString('yyyy-MM-dd')

$enDow = $dt.DayOfWeek.ToString()
$zhDow = $zh[$enDow]
$jpDow = $jp[$enDow]

$monthDir = Join-Path "log" (Join-Path $yyyy $mm)
$newFile  = Join-Path $monthDir ($ymd + ".md")
$template = Join-Path $repoRoot "templates\daily.md"

New-Item -ItemType Directory -Path $monthDir -Force | Out-Null

if (-not (Test-Path $newFile)) {
  if (Test-Path $template) {
    $content = Get-Content $template -Raw
    $content = $content.Replace('{{DATE_LINE}}', $ymd)
    $content = $content.Replace('{{DOW_ZH}}', $zhDow)
    $content = $content.Replace('{{DOW_JP}}', $jpDow)
    Set-Content -Path $newFile -Value $content -Encoding utf8
  } else {
    $fallback = "# $ymd`r`n`r`n> DOW: $zhDow ($jpDow)`r`n`r`n## Done`r`n- "
    Set-Content -Path $newFile -Value $fallback -Encoding utf8
  }
  Write-Host "Created: $newFile"
} else {
  Write-Host "Exists: $newFile"
}

# Open in VS Code (if available)
$code = "$env:LOCALAPPDATA\Programs\Microsoft VS Code\bin\code.cmd"
if (Test-Path $code) { & $code -g $newFile } else { Start-Process $newFile }
