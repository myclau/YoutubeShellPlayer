$wshell = New-Object -ComObject Wscript.Shell
$VideoDownloaderScriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$DiveLetter = $VideoDownloaderScriptPath[0]+":"

function Download-YoutubeVideo($url,$DownLoadPath,$quality="500"){

if(!(Test-path $DownLoadPath)){
    mkdir -Force $DownLoadPath | Out-Null
}

#see https://github.com/rg3/youtube-dl/blob/master/README.md#readme for reference
. "$VideoDownloaderScriptPath\youtube-dl.exe" --abort-on-error -o "$DownLoadPath\%(title)s.%(ext)s" -f "[height <=? $quality]" $url | Out-Null
if ($lastExitCode -eq 1){
write-host "DownLoad Error"
$wshell.Popup("DownLoad Error",0,"Exit 1")
exit 1
}
$path = gci $DownLoadPath | sort LastWriteTime | select -last 1

return $path.fullname
}


