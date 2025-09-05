param([string]$m = "daily updates")

$today = (Get-Date)
$null = & "$PSScriptRoot\new-entry.ps1" -Date $today.ToString('yyyy-MM-dd')

$zh = @{ Sunday='周日'; Monday='周一'; Tuesday='周二'; Wednesday='周三'; Thursday='周四'; Friday='周五'; Saturday='周六' }
$jp = @{ Sunday='日曜日'; Monday='月曜日'; Tuesday='火曜日'; Wednesday='水曜日'; Thursday='木曜日'; Friday='金曜日'; Saturday='土曜日' }
$en = $today.DayOfWeek.ToString()
$prefix = "{0} - {1} - {2}（{3}/{4}）" -f $today.ToString('MM'),$today.ToString('dd'),$today.ToString('yy'),$zh[$en],$jp[$en]

git add -A
git commit -m "$prefix $m"
git push
