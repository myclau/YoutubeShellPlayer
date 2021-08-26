# YoutubeShellPlayer
Play youtube in window with small shell with no border around it, can set opacity, suitable using in office hour

Pre-requisite
-----------------------------
1. you may need to have permission to execute powershell script
2. Check if your machine can run custom powershell script
```bash
PS C:\Users\xxxx> Get-ExecutionPolicy
Unrestricted
```
3. if not Unrestricted, open powershell and run as admin, then set it to Unrestricted
```bash
PS C:\WINDOWS\system32> Set-ExecutionPolicy Unrestricted

Execution Policy Change
The execution policy helps protect you from scripts that you do not trust. Changing the execution policy might expose
you to the security risks described in the about_Execution_Policies help topic at
https:/go.microsoft.com/fwlink/?LinkID=135170. Do you want to change the execution policy?
[Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help (default is "N"): A
PS C:\WINDOWS\system32>
```

How To Run
----------------------------------------
1. download zip from github and unzip it

2. Double click YoutubeShellPlayer.bat to start the Player

3. Then input the youtube url i.e. https://www.youtube.com/watch?v=XXxxXXxxXXxx

4. Then wait sometime for downloading.

5. After that it will pop up a no boarder window.

key and operation:
--------------------------------
1. Scroll up/down: +- Opacity
2. Mouse left:     Drag window
3. Mouse Right:    Close window
4. Space:          pause/play
5. Arrow left/right: +- time
6. Arrow up/down: +- Volume

Delete Cache
--------------------------------

If you want to delete the cache you can run DeleteCache.bat by double click it

PlayBack the Cache Video
----------------------------------------

If you want to PlayBack the Cache Video you can run PlayCacheVideo.bat by double click it

Software Requirement
-------------------------

1. Windows XP with Service Pack 2 or higher
2. .NET Framework 4.5 or higher (https://www.microsoft.com/en-us/download/details.aspx?id=30653)
3. Powershell 3.0 (https://www.microsoft.com/en-us/download/details.aspx?id=34595)

External Library
---------------------

1. youtube-dl (https://github.com/rg3/youtube-dl/blob/master/README.md) (support auto update downloader when need to download video from youtube [update @ 2021/08/26])
