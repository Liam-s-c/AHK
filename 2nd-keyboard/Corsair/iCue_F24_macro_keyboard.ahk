#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
;SetWorkingDir, C:\AHK\2nd-keyboard\ ;Or you could put the directory here. Whatevs.
Menu, Tray, Icon, shell32.dll, 174 ;this line changes the taskbar icon to a keyboard.

;;EXACT LOCATION FOR WHERE TO PUT THIS SCRIPT:
; C:\AHK\2nd-keyboard\Corsair\

;;Location for where to put a shortcut to this script, so that it will start with Windows:
;;  Here for just yourself:
;;  C:\Users\YOUR_USERNAME\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup
;;  Or here for all users:
;;  C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp
;tedgs - - - -  test test test
#NoEnv
SendMode Input
#InstallKeybdHook
;#InstallMouseHook ;<--You'll want to use this if you have scripts that use the mouse.
#UseHook On
#SingleInstance force ;only one instance of this script may run at a time!
#MaxHotkeysPerInterval 2000
#Include C:\AHK\functions.ahk
;;The lines below are optional. Delete them if you need to.
#HotkeyModifierTimeout 60 ; https://autohotkey.com/docs/commands/_HotkeyModifierTimeout.htm
#KeyHistory 200 ; https://autohotkey.com/docs/commands/_KeyHistory.htm ; useful for debugging.
#MenuMaskKey vk07 ;https://autohotkey.com/boards/viewtopic.php?f=76&t=57683
#WinActivateForce ;https://autohotkey.com/docs/commands/_WinActivateForce.htm ;prevent taskbar flashing.
;;The lines above are optional. Delete them if you need to.
detecthiddenwindows, on
;________________________________________________________________________________________=
;                                                                                        
;		  2ND KEYBOARD USING iCue (and the K55, though it'll work with any of them.)     
;  
;________________________________________________________________________________________


; https://www.corsair.com/us/en/Categories/Products/Gaming-Keyboards/Standard-Gaming-Keyboards/K55-RGB-Gaming-Keyboard/p/CH-9206015-NA

;;..............................................................................;;
;;............... BEGIN SECOND KEYBOARD iCue F24 ASSIGNMENTS ...................;;
;;..............................................................................;;


;; You should probably use something better than Notepad for your scripting. (Do NOT use Word.)
;; I use Notepad++ and Visual Studio Code. "Real" programmers recoil from it, but it's fine for my purposes.
;; https://notepad-plus-plus.org/
;; https://code.visualstudio.com/
;; You'll probably want the syntax highlighting: https://www.autohotkey.com/boards/viewtopic.php?t=50 ;<-- this is for Notepad++, 
;; Syntax highlighting fot Visual Stuido if you want syntax highlighting on Visual Studio press CTRL + SHIFT + X for the extentions page and search AutoHotKey



#if (getKeyState("F24", "P")) ;<--Everything after this line will only happen on the secondary keyboard that uses F24.
F24::return ;this line is mandatory for proper functionality, DO NOT REMOVE THIS LINE

escape::return
F1::return
F2::return
F3::return
F4::return
F5::return
F6::return
F7::return
F9::return
F8::return
F10::return
F11::return
F12::return
;;------------------------NEXT ROW--------------------------;;

`::return
1::return 
2::return
3::return
4::return
5::return
6::return
7::return
8::return
9::return
0::return
-::return
=::return
backspace::return

;;------------------------NEXT ROW--------------------------;;

tab::return
q::return
w::return
e::return
r::return
t::return
y::return
u::return
i::return
o::return
p::return
[::return
]::return
\::return
;;capslock::tooltip, [F24] capslock - this should have been remapped to F20. Keep this line commented out.

;;------------------------NEXT ROW--------------------------;;

a::return
s::return
d::return
f::return
g::return
h::return
j::return
K::return
l::return
`;::return
;for the above line, (semicolon) note that the ` is necessary as an escape character -- and that the syntax highlighting might get it wrong.
'::return
enter::return

;;------------------------NEXT ROW--------------------------;;

z::return
x::return
c::return
v::return

b::return

n::
{
WinMinimize, A
return
}
m::return
,::return
.::return
/::
{
If WinActive("ahk_exe chrome.exe")
	InputBox, foldername, Enter FolderName
	Sleep, 500
	Send, {CtrlDown}{ShiftDown}d
	Sleep, 500
	Send, %foldername%
	SendInput, {Enter}
If !WinActive("ahk_exe chrome.exe")
	return
return
}
space::
{
If !WinExist("ahk_exe chrome.exe")
	Run, chrome.exe
If WinActive("ahk_exe chrome.exe")
	SendInput {blind}^{tab}
else
	WinActivate ahk_exe chrome.exe
return
}
; [switch to chrome]

;;================= MODIFIERS REMAPPED ======================;;

SC070::
{
Send, import
return
}
;LShift -to-> SC070:International 2
;the following MUST use the UP stroke - the down stroke doesn't work.
SC071 up::
{
switchToExplorer()
return
}
;LCTRL to SC071:Language 2
SC072 up::InstantExplorer("E:\Downloads")
;LWin -to-> SC072:Language 1 [Instantly go to downloads folder]
SC073 up::
{
If !WinExist("ahk_exe notepad++.exe")
	Run, notepad++.exe
If WinActive("ahk_exe notepad++.exe")
	SendInput {blind}^{tab}
else
	WinActivate ahk_exe notepad++.exe
return
}
;LAlt -to-> SC073:International 1 [switch to notepad++]
SC077::
{
If !WinExist("ahk_exe discord.exe")
	Run, discord.exe
If WinExist("ahk_exe discord.exe")
	WinActivate, ahk_exe discord.exe
return
}
;RAlt -to-> SC077:Language 4 [switch to discord]
SC078::
{
sortByDateDescending()
return
}
;FN -to-> SC078:Language 3
SC079::
{
sortByDate()
return
}
;AppsKey (menu) -to-> SC079:International 4
SC07B::
{
Send ^+{PgUp}
return
}
;RCtrl -to-> SC07B:International 5 [Mute in discord]
SC07D::
{
Send, global
return
}
;RShift -to-> SC07D:International 3

;;================= LOCKING KEYS ======================;;

F20::return
;CapsLock -to-> SC06B:F20
SC05C::return
;NumLock -to-> SC05C:International 6
;Numlock is an AWFUL key. I prefer to leave it permanently on.
;It's been changed to International 6, so you can use it with no fear that it'll mess up your numpad.
;; ScrollLock is in the next section. iCue has no more extra keys that I could have used to swap it out with.

;;================= NEXT SECTION ======================;;

PrintScreen::return
ScrollLock::return
SC07E::return
;Pause -to-> SC07E:Brazillian comma

;;Don't use the 3 keys below for your 2nd keyboard!
;Pause::msgbox, The Pause/Break key is a huge PITA. That's why I remapped it to SC07E
;Break::msgbox, Or is it THIS key? WHO KNOWS!
;CtrlBreak::msgbox, I have no idea what Ctrlbreak is. But it shows up sometimes.
;;Don't use the 3 keys above for your 2nd keyboard! Just don't!!

insert::return
delete::return

home::return
end::return

pgup::return
pgdn::return

;;================= NEXT SECTION ======================;;

up::
{
{
If !WinExist("ahk_exe Spotify.exe")
	Run, Spotify.exe
If WinExist("ahk_exe Spotify.exe")
	WinActivate, ahk_exe Spotify.exe
}	
If !WinActive("ahk_exe spotify.exe")
	DetectHiddenWindows, On
	WinActivate, ahk_exe spotify.exe
	WinGet, winInfo, List, ahk_exe Spotify.exe
	Loop, %winInfo%
	{
		thisID := winInfo%A_Index%
		ControlFocus , , ahk_id %thisID%
		ControlSend, , ^s, ahk_id %thisID%
	}
Return
}
down::
{
If !WinExist("Calculator")
	Run, ahk_exe Calculator.exe
If WinExist("Calculator")
	WinActivate, Calculator
return
}
;[switch to calculator]
left::
{
If !WinExist("ahk_exe Spotify.exe")
	Run, Spotify.exe
If WinExist("ahk_exe Spotify.exe")
	WinActivate, ahk_exe Spotify.exe
return
}
;[switch to spotify]
right::
{
 Send, ^c
 Sleep 50
 Run, http://www.google.com/search?q=%clipboard%
Return
}
;[automatically google what every is in clipboard, if highlighted text then that.]

;;=========== THE NUMPAD WITH NUMLOCK ON ==============;;
numpad0::
{
Send, {Alt Down}
Sleep 100
Send, {Tab}
Sleep, 100
Send, {Alt Up}
return
}
numpad1::
{
InstantExplorer("C:\code")
return
}
numpad2::return
numpad3::return
numpad4::return
numpad5::return
numpad6::return
numpad7::return
numpad8::return
numpad9::return

;;============ THE NUMPAD WITH NUMLOCK OFF ============;;
numpadins::return
; Alt Tab
numpadend::return
numpaddown::return
numpadpgdn::return
numpadleft::return
numpadclear::return
numpadright::return
numpadhome::return
numpadup::return
numpadpgup::return
F19::
{
WinMaximize, A
return
}


;;====== NUMPAD KEYS THAT DON'T CARE ABOUT NUMLOCK =====;;
;;NumLock::tooltip, DO NOT USE THE NUMLOCK KEY IN YOUR 2ND KEYBOARD! I have replaced it with SC05C-International 6
numpadDiv::return
numpadMult::return
numpadSub::return
numpadAdd::return
numpadEnter::
{
Send, {PrintScreen}
Sleep 1500
Send, ^{PrintScreen}
return
}

numpadDot::return
#if ;this line will end the F24 secondary keyboard assignments. ;<-- ONLY REMOVE THIS LINE IF YOU NEED 


;;================= NEXT SECTION ======================;;
;; The K55 has 6 macro keys. I assigned them to F13-F18.
;; These keys are NOT WRAPPED. But you can do it that way (in iCue) if you like. 

F13::return
F14::return
F15::return
F16::return
F17::
{
Send, {raw}int(input(''))
Send, {Left}
Send, {Left}
Send, {Left}
Sleep 3000
return
}
F18::
{
If WinActive("ahk_exe chrome.exe")
	Send, ^t
If !WinActive("ahk_exe chrome.exe")
	return
return
}


F21::return
F22::return
F23::return