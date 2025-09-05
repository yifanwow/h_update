@echo off
setlocal
set "PS1=%~dp0new-entry.ps1"

REM Check if PowerShell 7 is installed, otherwise use Windows PowerShell
if exist "%ProgramFiles%\PowerShell\7\pwsh.exe" (
  "%ProgramFiles%\PowerShell\7\pwsh.exe" -NoProfile -ExecutionPolicy Bypass -File "%PS1%" %*
) else (
  "%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -ExecutionPolicy Bypass -File "%PS1%" %*
)
endlocal
