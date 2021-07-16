#SingleInstance force
#WinActivateForce
DetectHiddenWindows, On
WinGet, winInfo, List, ahk_exe Spotify.exe
WinMaximize, ahk_exe Spotify.exe
; hello
Loop, %winInfo%
{
	thisID := winInfo%A_Index%
	ControlFocus , , ahk_id %thisID%
	
	ControlSend, , ^{down}, ahk_id %thisID%
}
ExitApp
