@ECHO OFF

color 1a
SET ThisScriptsDirectory=%~dp0
SET "PowerShellScriptPath=%ThisScriptsDirectory%YoutubeShellPlayer.ps1"
::-windowstyle hidden 

Echo %errorlevel% |PowerShell  -windowstyle hidden -NoProfile -ExecutionPolicy Bypass  -Command "& '%PowerShellScriptPath%' -WarningAction SilentlyContinue ";
endlocal
