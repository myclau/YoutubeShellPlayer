$wshell = New-Object -ComObject Wscript.Shell
function VideoPlayer($VideoSource,$Option){
if(!(Test-path "$VideoSource")){
write-host "Debug:VideoSource=$VideoSource"
write-host "Video Source not found"
$wshell.Popup("Video Source not found",0,"Exit 1")
exit 1
}
#WPF Library for Playing Movie and some components
Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName System.ComponentModel
#XAML File of WPF as windows for playing movie
[xml]$XAML = @"
 
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="PowerShell Video Player" Height="360" Width="640" ResizeMode="CanMinimize">
    <Grid Margin="0,0,0,0">
        
        <MediaElement Height="360" Width="640" Name="VideoPlayer" LoadedBehavior="Manual" UnloadedBehavior="Stop" HorizontalAlignment="Stretch" VerticalAlignment="Stretch"/>
        <Label Content='[arrow L/R]+-time,[^/v]+-vol,[Scroll up/down]+-Opacity, [Mouse left] Drag window, [Mouse Right] Close window, [Space] pause/play' Name="label" HorizontalAlignment="right" Margin="5,5,5,5" VerticalAlignment="top"  FontSize="10" Foreground="white" />
        <Button Content="||" Name="PauseButton" Background="Transparent" Foreground="white" HorizontalAlignment="center" Margin="0,0,0,0" VerticalAlignment="center" FontSize="50" Height="80" Width="80" BorderThickness="0"  
    Style="{StaticResource {x:Static ToolBar.ButtonStyleKey}}"/>
        <Button Content=">" Name="PlayButton" Background="Transparent"  Foreground="white" HorizontalAlignment="center" Margin="0,0,0,0" VerticalAlignment="center" FontSize="65" Height="80" Width="80" BorderThickness="0"  
    Style="{StaticResource {x:Static ToolBar.ButtonStyleKey}}"/>
    <Slider Name="timelineSlider"   VerticalAlignment="bottom"  Margin="5" Width="600" HorizontalAlignment="Center" BorderThickness="0"  />
    </Grid>
</Window>
"@
 
#Devide All Objects on XAML
$XAMLReader=(New-Object System.Xml.XmlNodeReader $XAML)
$Window=[Windows.Markup.XamlReader]::Load( $XAMLReader )
$window.WindowStyle = 'None'
$Window.AllowsTransparency = $True
$Window.Opacity = 1
$global:flag="play"
$VideoPlayer = $Window.FindName("VideoPlayer")
$PauseButton = $Window.FindName("PauseButton")
$timelineSlider=  $Window.FindName("timelineSlider") 
$PlayButton = $Window.FindName("PlayButton")
$label = $Window.FindName("label")
#Video Default Setting
$VideoPlayer.Volume = 50;
$VideoPlayer.Source = $VideoSource

$VideoPlayer.Play()
$PauseButton.Visibility = [System.Windows.Visibility]::Visible
$PlayButton.Visibility = [System.Windows.Visibility]::Hidden
$timelineSlider.Opacity = 0
$PauseButton.Opacity = 0
$PlayButton.Opacity = 0
$label.Opacity = 0
$global:slider=$false
$window.Topmost = $true
$global:timer=New-Object System.Windows.Forms.Timer
$global:timer.Interval=1000
$global:timer.add_Tick({
    write-host $timelineSlider
    write-host $timelineSlider.value
    write-host $VideoPlayer.Position
    $timelineSlider.Value = $VideoPlayer.Position.TotalMilliseconds 
        

})



#[TimeSpan]::FromMilliseconds(10)

$VideoPlayer.Add_MediaOpened({
$MaximumTime = $VideoPlayer.NaturalDuration.TimeSpan.TotalMilliseconds
$timelineSlider.Maximum = $MaximumTime
$global:timer.Start()
})

$timelineSlider.Add_MouseDown({write-host !!!!!!UP})



$window.Add_MouseWheel({
write-host $_
write-host $_.Delta
write-host $Window.Opacity
if($_.Delta -gt 0){
    if($Window.Opacity -lt 1){
        $Window.Opacity= $Window.Opacity + 0.05
    }
} else {
    if($Window.Opacity -gt 0.1){
        $Window.Opacity= $Window.Opacity -0.05
    }
}

})
$Window.Add_KeyDown(
{
   #write-host $_
   write-host $_.key
   write-host Playing: $global:flag
   write-host Volume: $VideoPlayer.Volume
   write-host TotalTime: $VideoPlayer.Position.TotalMilliseconds
   write-host TimePosition: $VideoPlayer.Position
    If ($_.Key -eq "Space")
    {
        if($global:flag -eq "play"){
            $VideoPlayer.Pause()
            $global:flag="pause"
            $PauseButton.Visibility = [System.Windows.Visibility]::Hidden
            $PlayButton.Visibility = [System.Windows.Visibility]::Visible
        } else {
            $VideoPlayer.Play()
            $global:flag="play"
            $PauseButton.Visibility = [System.Windows.Visibility]::Visible
            $PlayButton.Visibility = [System.Windows.Visibility]::Hidden
        }
    }
    If ($_.Key -eq "Down"){
        if($VideoPlayer.Volume -gt 0){
        $VideoPlayer.Volume= $VideoPlayer.Volume - 10
        }else{
        $VideoPlayer.Volume= 0 
        }
    }
    If ($_.Key -eq "Up"){
        if($VideoPlayer.Volume -lt 100){
        $VideoPlayer.Volume= $VideoPlayer.Volume + 10
        }else{
        $VideoPlayer.Volume= 100 
        }
    }
     If ($_.Key -eq "Left"){
        if($VideoPlayer.Position -gt 0){
         $VideoPlayer.Position= $VideoPlayer.Position - "00:00:05"
        }else{
        $VideoPlayer.Position = 0
        }
    }
    If ($_.Key -eq "Right"){
        $VideoPlayer.Position= $VideoPlayer.Position + "00:00:05"
    }
})
$VideoPlayer.Add_MouseLeftButtonDown({
    $global:slider=$true
    $Window.DragMove()
    
    
    
    
})
$VideoPlayer.Add_MouseLeftButtonUp({
    $VideoPlayer.Position= [TimeSpan]::FromMilliseconds($timelineSlider.value)
    $global:slider=$false
    
    
    
})
$VideoPlayer.Add_MouseRightButtonDown({
    $global:timer.stop()
    $VideoPlayer.Pause()    
    $VideoPlayer.Stop();
    $VideoPlayer.Source = $null
    
    
    $Window.Close()

    
})

$Window.Add_MouseEnter({
$PauseButton.Opacity = 1
$PlayButton.Opacity = 1
$timelineSlider.Opacity = 1
$label.Opacity = 1
})
$Window.Add_MouseLeave({
$PauseButton.Opacity = 0
$PlayButton.Opacity = 0
$timelineSlider.Opacity = 0
$label.Opacity = 0
})

#Button click event 
$PlayButton.Add_Click({
    $VideoPlayer.Play()
    $global:flag="play"
    $PauseButton.Visibility = [System.Windows.Visibility]::Visible
    $PlayButton.Visibility = [System.Windows.Visibility]::Hidden
})
$PauseButton.Add_Click({
    $VideoPlayer.Pause()
    $global:flag="pause"
    $PauseButton.Visibility = [System.Windows.Visibility]::Hidden
    $PlayButton.Visibility = [System.Windows.Visibility]::Visible
})
 
#Show Up the Window
$Window.ShowDialog() | out-null


}
