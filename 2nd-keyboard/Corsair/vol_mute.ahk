#SingleInstance force
#WinActivateForce
DetectHiddenWindows, On
WinGet, winInfo, List, ahk_exe Spotify.exe
WinMaximize, ahk_exe Spotify.exe
Loop, %winInfo%
{
	thisID := winInfo%A_Index%
	ControlFocus , , ahk_id %thisID%
	
    
}
Click, -121 1000
ExitApp