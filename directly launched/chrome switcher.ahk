#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance force


SetTitleMatchMode, 2 ; approximate match
If WinActive("ahk_exe chrome.exe")
{
SendInput {blind}^{tab}
}
IfWinExist, - Google Chrome
{
WinActivate, - Google Chrome
}
IfWinNotExist, - Google Chrome
{
Run C:\Program Files\Google\Chrome\Application\chrome.exe
}
ExitApp