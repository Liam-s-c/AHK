#SingleInstance force
#NoEnv
#WinActivateForce
DetectHiddenWindows, On
WinGet, winInfo, List, ahk_exe Spotify.exe
WinMaximize, ahk_exe Spotify.exe
Loop, %winInfo%
{
	thisID := winInfo%A_Index%
	ControlFocus , , ahk_id %thisID%
	ControlSend, , ^{s}, ahk_id %thisID%
}
ExitApp