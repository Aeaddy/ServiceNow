[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") 
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") 

public static extern void mouse_event(long dwFlags, long dx, long dy, long cButtons, long dwExtraInfo);

$signature=@'
[DllImport("user32.dll",CharSet=CharSet.Auto,CallingConvention=CallingConvention.StdCall)]
public static extern void mouse_event(long dwFlags, long dx, long dy, long cButtons, long dwExtraInfo);
'@
$SendMouseClick = Add-Type -memberDefinition $signature -name "Win32MouseEventNew" -namespace Win32Functions -passThru

Add-Type -AssemblyName System.Windows.Forms
[Reflection.Assembly]::LoadWithPartialName("System.Drawing")


function screenshot([Drawing.Rectangle]$bounds, $path) {
   $bmp = New-Object Drawing.Bitmap $bounds.width, $bounds.height
   $graphics = [Drawing.Graphics]::FromImage($bmp)

   $graphics.CopyFromScreen($bounds.Location, [Drawing.Point]::Empty, $bounds.size)

   $bmp.Save($path)

   $graphics.Dispose()
   $bmp.Dispose()

   sleep 2
}


$wshell = New-Object -ComObject wscript.shell;

$numberOfPages = 479 # The number of pages in the manual.

Sleep 3 # You have three seconds to find the window with the manual and bring it to the top,
        # make it full screen with F11
        # click/highlight the down-arrow button
        
# https://docs.microsoft.com/en-us/dotnet/api/system.windows.forms.sendkeys?redirectedfrom=MSDN&view=netframework-4.8

# [System.Windows.Forms.SendKeys]::SendWait('{F11}') # Go fullscreen


For ($i=0; $i -le $numberOfPages; $i++) {

$filename = "C:\Users\Robert Lankford\Google Drive\Virtual File Cabinet\Employment\Robert\ITS Partners, LLC\Training\SAMP_book\$i.png"
#$X = [System.Windows.Forms.Cursor]::Position.X
#$Y = [System.Windows.Forms.Cursor]::Position.Y
#Write-Output "X: $X | Y: $Y"

$bounds = [Drawing.Rectangle]::FromLTRB(1210, 99, 2756, 2083) #2685, 2055
screenshot $bounds $filename

#[System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($X, $Y)

#[System.Windows.Forms.SendKeys]::SendWait('{ENTER}')

sleep -Seconds 2

$SendMouseClick::mouse_event(0x00000002, 0, 0, 0, 0); # Left Mouse Down
$SendMouseClick::mouse_event(0x00000004, 0, 0, 0, 0); # Left Mouse Up

sleep -Seconds 2
    
}



