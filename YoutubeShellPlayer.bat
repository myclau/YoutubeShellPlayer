@ECHO OFF

color 1a
SET ThisScriptsDirectory=%~dp0
SET "PowerShellScriptPath=%ThisScriptsDirectory%Script\YoutubeShellPlayer.ps1"
::-windowstyle hidden 

Echo %errorlevel% |PowerShell  -windowstyle hidden -NoProfile -ExecutionPolicy Bypass  -Command "& '%PowerShellScriptPath%' -WarningAction SilentlyContinue ";
:: for debug
::Echo %errorlevel% |PowerShell   -NoProfile -ExecutionPolicy Bypass  -Command "& '%PowerShellScriptPath%' -WarningAction SilentlyContinue ";
endlocal
