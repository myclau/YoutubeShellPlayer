 Function Get-FileName($initialDirectory)
{
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null
    
    $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $OpenFileDialog.initialDirectory = $initialDirectory
    $OpenFileDialog.filter = "ALL (*.*)| *.*"
    $OpenFileDialog.ShowDialog() | Out-Null
    $OpenFileDialog.filename
} 

$wshell = New-Object -ComObject Wscript.Shell
$YoutubeShellPlayerScriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$YoutubeShellPlayerRootScriptPath = Split-Path -Parent $YoutubeShellPlayerScriptPath
. "$YoutubeShellPlayerRootScriptPath\Lib\VideoDownloader\VideoDownloader.ps1"
. "$YoutubeShellPlayerRootScriptPath\Lib\VideoPlayer\VideoPlayer.ps1"

$DownLoadPath = "$YoutubeShellPlayerRootScriptPath\YouTubeVideoCache"

if(!(Test-Path $DownLoadPath)){
    mkdir $DownLoadPath -Force
}



$videoLocation = Get-FileName $DownLoadPath
if($videoLocation -eq ""){
exit
}
if (Test-path $videoLocation){
VideoPlayer "$videoLocation"
} else {
$wshell.Popup("Video not found",0,"Exit 1")
}


