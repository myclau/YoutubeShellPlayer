

Function Update-Window {
    Param (
        $Control,
        $Property,
        $Value,
        [switch]$AppendContent
    )

   # This is kind of a hack, there may be a better way to do this
   If ($Property -eq "Close") {
      $syncHash.Window.Dispatcher.invoke([action]{$syncHash.Window.Close()},"Normal")
      Return
   }
  
   # This updates the control based on the parameters passed to the function
   $syncHash.$Control.Dispatcher.Invoke([action]{
      # This bit is only really meaningful for the TextBox control, which might be useful for logging progress steps
       If ($PSBoundParameters['AppendContent']) {
           $syncHash.$Control.AppendText($Value)
       } Else {
           $syncHash.$Control.$Property = $Value
       }
   }, "Normal")
}
       

[System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic') | Out-Null
$wshell = New-Object -ComObject Wscript.Shell
$YoutubeShellPlayerScriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$YoutubeShellPlayerRootScriptPath = Split-Path -Parent $YoutubeShellPlayerScriptPath
. "$YoutubeShellPlayerRootScriptPath\Lib\VideoDownloader\VideoDownloader.ps1"
. "$YoutubeShellPlayerRootScriptPath\Lib\VideoPlayer\VideoPlayer.ps1"
$DownLoadPath = "$YoutubeShellPlayerRootScriptPath\YouTubeVideoCache"


$YoutubeUrl = [Microsoft.VisualBasic.Interaction]::InputBox("Enter The Youtube Url")
$YoutubeUrl
if ($YoutubeUrl -ne ""){
#add progress bar
[void][System.Reflection.Assembly]::LoadWithPartialName('presentationframework')
$syncHash = [hashtable]::Synchronized(@{})
$newRunspace =[runspacefactory]::CreateRunspace()
$newRunspace.ApartmentState = "STA"
$newRunspace.ThreadOptions = "ReuseThread"          
$newRunspace.Open()
$newRunspace.SessionStateProxy.SetVariable("syncHash",$syncHash)          
$psCmd = [PowerShell]::Create().AddScript({   
    [xml]$xaml = @"
    <Window
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        x:Name="Window" Title="Progress..." WindowStartupLocation = "CenterScreen"
        Width = "335" Height = "130" ShowInTaskbar = "True">
        <Grid>
           <ProgressBar x:Name = "ProgressBar" Height = "20" Width = "300" HorizontalAlignment="Left" VerticalAlignment="Top" Margin = "10,10,0,0"/>
           <Label x:Name = "Label1" Height = "30" Width = "300" HorizontalAlignment="Left" VerticalAlignment="Top" Margin = "10,35,0,0"/>
           <Label x:Name = "Label2" Height = "30" Width = "300" HorizontalAlignment="Left" VerticalAlignment="Top" Margin = "10,60,0,0"/>
        </Grid>
    </Window>
"@
 
    $reader=(New-Object System.Xml.XmlNodeReader $xaml)
    $syncHash.Window=[Windows.Markup.XamlReader]::Load( $reader )
    $syncHash.ProgressBar = $syncHash.Window.FindName("ProgressBar")
    $syncHash.Label1 = $syncHash.Window.FindName("Label1")
    $syncHash.Label2 = $syncHash.Window.FindName("Label2")
    $syncHash.Window.ShowDialog() | Out-Null
    $syncHash.Error = $Error
})
$psCmd.Runspace = $newRunspace
$data = $psCmd.BeginInvoke()
While (!($syncHash.Window.IsInitialized)) {
   Start-Sleep -S 1
}


######################
While (!($syncHash.Window.IsInitialized)) {
   Start-Sleep -S 1
}
Update-Window Label1 Content "Establish connection"  
Update-Window ProgressBar Value 0
$Count=1
for($i=0;$i -lt 5;$i++){
   Update-Window ProgressBar Value "$Count"
   $count+=6
}
Update-Window Label1 Content "DownLoading Video From YouTube"  
$videoLocation = Download-YoutubeVideo "$YoutubeUrl" $DownLoadPath

if ($lastExitCode -eq 1){
Update-Window Window Close
exit 1
}
$videoLocation
for($i=0;$i -lt 5;$i++){
   Update-Window ProgressBar Value "$Count"
   $count+=14
}
Update-Window Label2 Content "$computer`Downloaded"
Update-Window ProgressBar Value 100
sleep 3
Update-Window Window Close



VideoPlayer "$videoLocation"
} else {
$wshell.Popup("No Input",0,"Exit 1")
}


