
#SingleInstance force 
Menu, Tray, Icon, shell32.dll, 48 ;this makes the little icon in the taskbar a padlock!=
#installkeybdhook

SetNumLockState,On
SetNumLockState,AlwaysOn
return

;https://autohotkey.com/boards/viewtopic.php?t=21434
