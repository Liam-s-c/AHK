#NoEnv
#SingleInstance force
#WinActivateForce
DetectHiddenWindows, On
WinGet, winInfo, List, ahk_exe Spotify.exe
Loop, %winInfo%
{
	thisID := winInfo%A_Index%
	ControlFocus , , ahk_id %thisID%
	WinMaximize, ahk_id %thisID%
	ControlSend, , {Space}, ahk_id %thisID%
}
ExitApp