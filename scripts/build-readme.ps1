$repoRoot = Split-Path -Parent $PSScriptRoot
Set-Location $repoRoot

$logRoot = Join-Path $repoRoot "log"
$files = if (Test-Path $logRoot) {
  Get-ChildItem $logRoot -Recurse -Filter *.md | Sort-Object FullName
} else { @() }

# 头部说明
$sb = New-Object System.Text.StringBuilder
[void]$sb.AppendLine("# Home Updates Journal")
[void]$sb.AppendLine()
[void]$sb.AppendLine("> 目录按 年 / 月 归档。此 README 由脚本自动生成（scripts/build-readme.ps1）。")
[void]$sb.AppendLine()
[void]$sb.AppendLine("— 最新更新：$(Get-Date -Format 'yyyy-MM-dd HH:mm') —")
[void]$sb.AppendLine()
[void]$sb.AppendLine("## 目录")
[void]$sb.AppendLine()

# 按 年-月 分组（降序）
$groups = $files | Group-Object {
  if ($_ -and $_.FullName -match 'log[\\/](\d{4})[\\/](\d{2})[\\/]') {
    "{0}-{1}" -f $Matches[1], $Matches[2]
  } else { "其他" }
}

foreach ($g in ($groups | Sort-Object Name -Descending)) {
  $ym = $g.Name
  if ($ym -eq "其他") { continue }
  $count = $g.Count
  [void]$sb.AppendLine("<details open><summary><strong>$ym</strong>（$count）</summary>")
  [void]$sb.AppendLine()

  foreach ($f in ($g.Group | Sort-Object Name)) {
    $date = [regex]::Match($f.Name,'\d{4}-\d{2}-\d{2}').Value
    $rel  = $f.FullName.Substring($repoRoot.Length).TrimStart('\','/').Replace('\','/')

    $raw  = Get-Content $f.FullName -Raw

    # 摘要：抓“## ✅ 做了什么”下面第一条 bullet
    $m = [regex]::Match($raw, "(?ms)##\s*✅.*?\r?\n-\s*(.+)")
    $summary = if ($m.Success) { $m.Groups[1].Value.Trim() } else { "" }
    if ($summary.Length -gt 80) { $summary = $summary.Substring(0,80) + "…" }

    if ([string]::IsNullOrWhiteSpace($summary)) {
      [void]$sb.AppendLine("- **$date** — [$($f.Name)]($rel)")
    } else {
      [void]$sb.AppendLine("- **$date** — [$summary]($rel)")
    }
  }

  [void]$sb.AppendLine()
  [void]$sb.AppendLine("</details>")
  [void]$sb.AppendLine()
}