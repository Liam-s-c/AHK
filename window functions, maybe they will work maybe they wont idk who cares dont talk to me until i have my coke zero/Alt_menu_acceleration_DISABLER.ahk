Menu, Tray, Icon, shell32.dll, 110 ; changes the icon to a 🚫

;SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#InstallKeybdHook
#NoEnv
;#NoTrayIcon ;comment this in if you do not want a tray icon.
#SingleInstance
#MaxHotkeysPerInterval 2000
Process, Priority, , H
SendMode Input
#SingleInstance force

;These next two lines are very important. You have to change the "menu mask key" away from being CTRL, to something that won't result in cross-talk. Read this thread to learn the details: https://autohotkey.com/boards/viewtopic.php?f=76&t=57683
#MenuMaskKey vk07  ; vk07 is unassigned. =
#UseHook

;; take this tutorial if you don't know how AHK works. https://www.autohotkey.com/docs/Tutorial.htm


;; If this script isn't working for you, try Alt_menu_acceleration_DISABLER_using_F13.ahk


;;;; THE READ ME IS BELOW. TRUST ME, YOU SHOULD READ IT. BUT FIRST... ;;;;


; *********** IS THE WINDOWS / XBOX GAME BAR GETTING IN YOUR WAY? ************
; ****************** OR MAYBE IT'S THE NVIDIA SHARE OVERLAY! *****************
; ============================================================================
; ************* HERE ARE THE INSTRUCTIONS FOR HOW TO FIX THAT! ***************
; ============================================================================

; You will need to disable Windows Game Bar, or at least change or disable the shortcuts! Just hit the windows key and search for "game bar settings." Click on that and turn it OFF. Here is a picture of that process: https://i.imgur.com/yQlOB38.png or https://github.com/TaranVH/2nd-keyboard/blob/master/Taran's_Windows_Mods/HOW_TO_DISABLE_GAME_BAR.png

;ALSO, IF YOU HAVE AN NVIDIA GPU, AND YOUR "SHARE" OVERLAY IS ENABLED, YOU WILL NEED TO DISABLE THE "Broadcast LIVE" OVERLAY! You do this from the GEFORCE EXPERIENCE application. Then you click the little triangle that says "Open in-game overlay." Click on the gear, then click on "Broadcast LIVE." Then click the little slider to turn that OFF!!

;EXPLANATION: For some reason, any scan code above SC07F, or any unused virtual key, when preceeded with ALT, acts as the shortcut to enable the game bar or Broadcast Live overlay. I have no idea why this is. It's very frustrating. Those shortcuts cannot be disabled or changed. So you have to disable the thing that it triggers, instead. If you want to use the game bar, AND you want to use the ALT nullifier, you're out of luck. I have no way to do it. Let me know if you figure it out!

; =============================================================================


; ===== TO USE THE SCRIPT: ===== (This applies to the .exe and .ahk -- they are exactly the same.)


;Note that the script will add a little red 🚫 to your taskbar, which can be right clicked to be disabled or exited from the menu.

; You can hold down both ALT keys whenever you want to easily toggle this script on and off. This is useful for things like Premiere's keyboard shortcuts menu, which has ALT-nullification of its own.

