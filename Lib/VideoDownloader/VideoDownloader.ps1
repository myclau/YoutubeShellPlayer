$wshell = New-Object -ComObject Wscript.Shell
$VideoDownloaderScriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$DiveLetter = $VideoDownloaderScriptPath[0]+":"
$downloaderEXE_dir="$VideoDownloaderScriptPath\youtube-dl.exe"
$downloadergithub="ytdl-org/youtube-dl"
$PSDefaultParameterValues['*:Encoding'] = 'utf8'
function Download-YoutubeVideo($url,$DownLoadPath,$quality="500"){

if(!(Test-path $DownLoadPath)){
    mkdir -Force $DownLoadPath | Out-Null
}

Check-Downloader-Version

#see https://github.com/rg3/youtube-dl/blob/master/README.md#readme for reference
. "$downloaderEXE_dir" --abort-on-error -o "$DownLoadPath\%(title)s.%(ext)s" -f "[height <=? $quality]" $url | Out-Null
if ($lastExitCode -eq 1){
write-host "DownLoad Error"
$wshell.Popup("DownLoad Error",0,"Exit 1")
exit 1
}
$path = gci $DownLoadPath | sort CreationTime  | select -last 1

return $path.fullname
}

function Check-Downloader-Version(){
    $releases_info=$(Invoke-WebRequest -Uri "https://api.github.com/repos/$downloadergithub/releases/latest").content | ConvertFrom-Json
    $downloader_latest_release_download_info=$($releases_info.assets | where { $_.name -eq "youtube-dl.exe" })
    $downloader_download_url=$downloader_latest_release_download_info.browser_download_url
    $download_latest_version=$releases_info.tag_name
    if(!(Test-path "$downloaderEXE_dir")){
        Invoke-WebRequest -Uri "$downloader_download_url" -OutFile "$downloaderEXE_dir"
    }
    $current_downloader_version=$(. "$downloaderEXE_dir" --version)
    if ( "$current_downloader_version" -eq $download_latest_version) {
        #echo "version is up to date"
    }else{
        #echo "version is not update, will redownload"
        #echo "Removing downloader"
        Remove-Item "$downloaderEXE_dir"
        #echo "Downloading downloader"
        Invoke-WebRequest -Uri "$downloader_download_url" -OutFile "$downloaderEXE_dir"
    }

}
