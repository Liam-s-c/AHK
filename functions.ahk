#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance force
#WinActivateForce


InstantExplorer(f_path,pleasePrepend := 0)
{
;this has been heavily modified from https://autohotkey.com/docs/scripts/FavoriteFolders.htm

;I feel ambivilant about this line. It'll be more stable, but it'll be a bit sloooowerrrr!
keywait, %A_priorhotkey% ;should there be a timeout clause? this still works even when launched with no hotkey, hmm.

sendinput, {blind}{SC0E8} ;scan code of an unassigned key. This is needed to prevent the item from merely FLASHING on the task bar, rather than opening the folder. Don't ask me why, but this works. Also, this is helpful for debugging.

instantExplorerTryAgain:

if !FileExist(f_path)
{
	;MsgBox,,, %f_path%`nNo such path exists`, but we will go down in folders until it does.,1.0
	
	if InStr(f_path, "\"){
	
		FoundPos := InStr(f_path, "\", , StartingPos := 0, Occurrence := 1)
		;msgbox % FoundPos
		
		Length := StrLen(f_path)
		
		;StringLeft, OutputVar, InputVar, Count
		
		trimThis := Length - FoundPos
		
		;msgbox % trimThis
		
		NewString := SubStr(f_path, 1, FoundPos-1)
		;msgbox, NewString is %NewString%
		f_path := NewString
		GOTO, instantExplorerTryAgain
		;oh my god this code is so sloppy, it's great. And this is like, one of my best ever functions. I'm not even kidding. I use it like 20x an hour.
	}
	else
	{
		MsgBox,,, %f_path%`n`nNo such path exists.,1.0
		GOTO, instantExplorerEnd
		
	}
}

f_path = %f_path%\ ;;THIS ADDS A \ AT THE VERY END OF THE FILE PATH, FOR THE SAKE OF OLD-STYLE SAVE AS DIALOUGE BOXES WHICH REQUIRE THEM IN ORDER TO UPDATE THE FOLDER PATH WHEN IT IS INSERTED INTO Edit1.

;msgbox, f_path is currently %f_path% ;just debugging as usual

f_path := """" . f_path . """" ;this adds quotation marks around everything so that it works as a string, not a variable. 

;but also, the old style still dopesn't like the quotation marks, and I'm not sure how to detect it since i know almost nothing about it. ho hum. But it does have ClassNN:	SysListView321 which MAYBE i could use with this code https://autohotkey.com/board/topic/9362-detect-opensave-dialog/ but i dont know. saving this for later.

;msgbox, f_path is now finally %f_path%

;SoundBeep, 900, 400 ;this is dumb because you cant change the volume, or tell it NOT to wait while the sound plays...

; These first few variables are set here and used by f_OpenFavorite:
WinGet, f_window_id, ID, A
WinGetClass, f_class, ahk_id %f_window_id%
WinGetTitle, f_title, ahk_id %f_window_id% ;to be used later to see if this is the export dialouge window in Premiere...
if f_class in #32770,ExploreWClass,CabinetWClass  ; if the window class is a save/load dialog, or an Explorer window of either kind.
	ControlGetPos, f_Edit1Pos, f_Edit1PosY,,, Edit1, ahk_id %f_window_id%


	;edit2
/*
if f_AlwaysShowMenu = n  ; The menu should be shown only selectively.
{
	if f_class in #32770,ExploreWClass,CabinetWClass  ; Dialog or Explorer.
	{
		if f_Edit1Pos =  ; The control doesn't exist, so don't display the menu
			return
	}
	else if f_class <> ConsoleWindowClass
		return ; Since it's some other window type, don't display menu.
}
; Otherwise, the menu should be presented for this type of window:
;Menu, Favorites, show
*/

;msgbox, A_ThisMenuItemPos %A_ThisMenuItemPos%
;msgbox, A_ThisMenuItem %A_ThisMenuItem%
;msgbox, A_ThisMenu %A_ThisMenu%

;;StringTrimLeft, f_path, f_path%A_ThisMenuItemPos%, 0
; msgbox, f_path: %f_path%`n f_class:  %f_class%`n f_Edit1Pos:  %f_Edit1Pos%

; f_OpenFavorite:
;msgbox, BEFORE:`n f_path: %f_path%`n f_class:  %f_class%`n f_Edit1Pos:  %f_Edit1Pos%

; Fetch the array element that corresponds to the selected menu item:
;;StringTrimLeft, f_path, f_path%A_ThisMenuItemPos%, 0
if f_path =
	return

if f_class = EVERYTHING    ; It's Everything search. I want to put the fodler name in quotes in the main field, because that's how you search a subdirectory.
{
ControlGetPos, f_Edit1Pos, f_Edit1PosY,,, Edit1, ahk_id %f_window_id%
;msgbox, this is Everything search`nf_Edit1Pos = %f_Edit1Pos%

if f_Edit1Pos <>   ; we know it should have an Edit1 control.
	{
	ControlFocus, Edit1, ahk_id %f_window_id%
	
	WinActivate ahk_id %f_window_id%
	
	f_path := f_path . " " ;this adds a space to the end, so i can type the actual thing to search for afterwards.

	ControlSetText, Edit1, %f_path%, ahk_id %f_window_id%
	;(it adds a space to the end too.)
	sleep 2
	ControlFocus, DirectUIHWND2, ahk_id %f_window_id% ;to try to get the focus back into the center area, so you can now type letters and have it go to a file or fodler, rather than try to SEARCH or try to change the FILE NAME by default.
	send, {end} ;to get to the end of the search box. best place to search for the actual thing i want to find.
	return
	}

GOTO, instantExplorerEnd 
}



if f_class = #32770    ; It's a dialog.
	{

	if WinActive("ahk_exe waifu2x-caffe.exe")
		{
		tooltip, you are inside of Waifu2x
		
		GOTO, ending2
		;this will open an explorer window rather than trying to change waifu2x's input path as it otherwise would.
		}
	
	if WinActive("ahk_exe Adobe Premiere Pro.exe")
		{
		tooltip, you are inside of premiere
		
		if (f_title = "Export Settings") or if (f_title = "Link Media")
			{
			msgbox,,,you are in Premiere's export window or link media window, but NOT in the "Save as" inside of THAT window. no bueno, 1
			GOTO, instantExplorerEnd 
			;return ;no, I don't want to return because i still want to open an explorer window.
			}
		
		
		If InStr(f_title, "Link Media to") ;Note that you must have "use media browser to locate files" UNCHECKED because it is GARBAGE.
			{
			tooltip, you are inside Premieres relinker.
			; This requires custom code, because the EditX boxes are different:
			; last path   = Edit1
			; filename    = Edit2
			; address bar = Edit3

			ControlFocus, Edit2, ahk_id %f_window_id% 

			tooltip, you are inside the link media thingy
			sleep 1
			
			WinActivate ahk_id %f_window_id%
			sleep 1
			ControlGetText, f_text, Edit2, ahk_id %f_window_id%
			sleep 1
			ControlSetText, Edit2, %f_path%, ahk_id %f_window_id%
			ControlSend, Edit2, +{Enter}, ahk_id %f_window_id%
			Sleep, 100  ; It needs extra time on some dialogs or in some cases.
			ControlSetText, Edit2, %f_text%, ahk_id %f_window_id%
			;msgbox, AFTER:`n f_path: %f_path%`n f_class:  %f_class%`n f_Edit1Pos:  %f_Edit1Pos%
			
			tooltip,
			return		
			}

		if (f_title = "Save As") or if (f_title = "Save Project")
			{
			;;;ControlGetPos, f_Edit1Pos, f_Edit1PosY,,, Edit1, ahk_id %f_window_id%
			;ControlFocus, Edit2, ahk_id %f_window_id% ;we know that Edit2 is the address bar in this case. So there's no need to use Edit1 and then swap back in the filename.
			
			ControlFocus, Edit1, ahk_id %f_window_id% 
			;msgbox,,,you are hereee,0.5
			tooltip, you are here
			sleep 1
			;tippy2("DIALOUGE WITH PREMIERE'S Edit1`n`nLE controlfocus of Edit1 for f_window_id was just engaged.", 2000)
			; msgbox, is it in focus?
			; MouseMove, f_Edit1Pos, f_Edit1PosY, 0
			; sleep 10
			; click
			; sleep 10
			; msgbox, how about now? x%f_Edit1Pos% y%f_Edit1PosY%
			;msgbox, Edit1 has been clicked maybe
			
			; Activate the window so that if the user is middle-clicking
			; outside the dialog, subsequent clicks will also work:
			WinActivate ahk_id %f_window_id%
			; Retrieve any filename that might already be in the field so
			; that it can be restored after the switch to the new folder:
			ControlGetText, f_text, Edit1, ahk_id %f_window_id%
			sleep 1
			ControlSetText, Edit1, %f_path%, ahk_id %f_window_id%
			ControlSend, Edit1, +{Enter}, ahk_id %f_window_id%
			Sleep, 100  ; It needs extra time on some dialogs or in some cases.
			ControlSetText, Edit1, %f_text%, ahk_id %f_window_id%
			;msgbox, AFTER:`n f_path: %f_path%`n f_class:  %f_class%`n f_Edit1Pos:  %f_Edit1Pos%
			
			tooltip,
			return
			tooltip, do you make it this far
			tooltip, the answer is no. the RETURN ends it properly
			GOTO, instantExplorerEnd 
			;But i have the GOTO just in case, hahahaha
			}
		}

	; stuff beyond here is NOT in premiere
	if f_Edit1Pos <>   ; And it has an Edit1 control.
		{

		ControlFocus, Edit1, ahk_id %f_window_id% ;this is really important.... it doesn't work if you don't do this...
		;tippy2("DIALOUGE WITH EDIT1`n`nwait really?`n`nLE controlfocus of edit1 for f_window_id was just engaged.", 1000)
		; msgbox, is it in focus?
		; MouseMove, f_Edit1Pos, f_Edit1PosY, 0
		; sleep 10
		; click
		; sleep 10
		; msgbox, how about now? x%f_Edit1Pos% y%f_Edit1PosY%
		;msgbox, edit1 has been clicked maybe
		
		; Activate the window so that if the user is middle-clicking
		; outside the dialog, subsequent clicks will also work:
		WinActivate ahk_id %f_window_id%
		
		; Retrieve any filename that might already be in the field so
		; that it can be restored after the switch to the new folder:
		ControlGetText, f_text, Edit1, ahk_id %f_window_id%
		sleep 2
		ControlSetText, Edit1, %f_path%, ahk_id %f_window_id%
		sleep 3
		ControlSend, Edit1, {Enter}, ahk_id %f_window_id%
		Sleep, 100  ; It needs extra time on some dialogs or in some cases.
		
		;now RESTORE the filename in that text field. I don't like doing it this way...
		ControlSetText, Edit1, %f_text%, ahk_id %f_window_id%
		;msgbox, AFTER:`n f_path: %f_path%`n f_class:  %f_class%`n f_Edit1Pos:  %f_Edit1Pos%
		sleep 2
		ControlFocus, DirectUIHWND2, ahk_id %f_window_id% ;to try to get the focus back into the center area, so you can now type letters and have it go to a file or fodler, rather than try to SEARCH or try to change the FILE NAME by default.
		return
		}
	; else fall through to the bottom of the subroutine to take standard action.
	}

;for some reason, the following code just doesn't work well at all.
/*
else if f_class in ExploreWClass,CabinetWClass  ; In Explorer, switch folders.
{
	tooltip, f_class is %f_class% and f_window_ID is %f_window_id%
	if f_Edit1Pos <>   ; And it has an Edit1 control.
	{
		Tippy2("EXPLORER WITH EDIT1 only 2 lines of code here....", 1000)
		ControlSetText, Edit1, %f_path%, ahk_id %f_window_id%
		msgbox, ControlSetText happened. `nf_class is %f_class% and f_window_ID is %f_window_id%`nAND f_Edit1Pos is %f_Edit1Pos%
		; Tekl reported the following: "If I want to change to Folder L:\folder
		; then the addressbar shows http://www.L:\folder.com. To solve this,
		; I added a {right} before {Enter}":
		ControlSend, Edit1, {Right}{Enter}, ahk_id %f_window_id%
		return
	}
	; else fall through to the bottom of the subroutine to take standard action.
}
*/

else if f_class = ConsoleWindowClass ; In a console window, CD to that directory
	{
	WinActivate, ahk_id %f_window_id% ; Because sometimes the mclick deactivates it.
	SetKeyDelay, 0  ; This will be in effect only for the duration of this thread.
	IfInString, f_path, :  ; It contains a drive letter
		{
		StringLeft, f_path_drive, f_path, 1
		Send %f_path_drive%:{enter}
		}
	Send, cd %f_path%{Enter}
	return
	}
ending2:
; Since the above didn't return, one of the following is true:
; 1) It's an unsupported window type but f_AlwaysShowMenu is y (yes).
; 2) It's a supported type but it lacks an Edit1 control to facilitate the custom
;    action, so instead do the default action below.
;Tippy2("end was reached.",333)
;SoundBeep, 800, 300 ;this is nice but the whole damn script WAITS for the sound to finish before it continues...
; Run, Explorer %f_path%  ; Might work on more systems without double quotes.

;msgbox, f_path is %f_path%

; SplitPath, f_path, , OutDir, , ,
; var := InStr(FileExist(OutDir), "D")

; if (var = 0)
	; msgbox, directory does not exist
; else if var = 1
	Run, %f_path%  ; I got rid of the "Explorer" part because it caused redundant windows to be opened, rather than just switching to the existing window
;else
;	msgbox,,,Directory does not exist,1

instantExplorerEnd:
tooltip,
}
;end of instantexplorer()

JEE_ExpWinGetObj(hWnd)
{
	for oWin in ComObjCreate("Shell.Application").Windows
		if (oWin.HWND == hWnd)
			break
	return oWin
}

;========== I, TARAN, DID NOT WRITE THIS CODE, AND POSSIBLY DON'T USE IT ============

;e.g. JEE_ExpGetInterfaces(oWin, isp, isb, isv, ifv2, icm)
;e.g. isp := isb := isv := ifv2 := icm := ""
JEE_ExpGetInterfaces(oWin, ByRef isp="", ByRef isb="", ByRef isv="", ByRef ifv2="", ByRef icm="")
{
	isp := ComObjQuery(oWin, "{6d5140c1-7436-11ce-8034-00aa006009fa}")
	, isb := ComObjQuery(isp, "{4C96BE40-915C-11CF-99D3-00AA004AE837}", "{000214E2-0000-0000-C000-000000000046}")
	if (DllCall(NumGet(NumGet(isb+0)+15*A_PtrSize), Ptr,isb, PtrP,isv) < 0) ;QueryActiveShellView
		return
	ifv2 := ComObjQuery(isv, "{1af3a467-214f-4298-908e-06b03e0b39f9}")
	icm := ComObjQuery(ifv2, "{d8ec27bb-3f3b-4042-b10a-4acfd924d453}")
}

;========== I, TARAN, DID NOT WRITE THIS CODE, AND POSSIBLY DON'T USE IT ============

;custom abbreviation to canonical property name
JEE_ExpColAbbrevToName(vList, vDelim="`n")
{
	oArray := {nam:"System.ItemNameDisplay"
	,siz:"System.Size"
	,typ:"System.ItemTypeText"
	,mod:"System.DateModified"
	,cre:"System.DateCreated"
	,acc:"System.DateAccessed"
	,dat:"System.ItemDate"
	,dur:"System.Calendar.Duration"
	,dim:"System.Image.Dimensions"
	,len:"System.Media.Duration"}

	vOutput := ""
	Loop, Parse, vList, % vDelim
		vOutput .= ((A_Index = 1) ? "" : vDelim) oArray[A_LoopField]
	return vOutput
}

;==================================================

;IColumnManager interface (Windows)
;https://msdn.microsoft.com/en-us/library/windows/desktop/bb776149(v=vs.85).aspx
;methods (8): C:\Program Files (x86)\Windows Kits\8.1\Include\um\ShObjIdl.h

;========== I, TARAN, DID NOT WRITE THIS CODE, AND POSSIBLY DON'T USE IT ============

JEE_ICMGetColumnCount(icm, vMode="")
{
	vFlags := InStr(vMode, "a") ? 0x1 : 0x2
	;CM_ENUM_VISIBLE := 0x2 ;CM_ENUM_ALL := 0x1
	DllCall(NumGet(NumGet(icm+0)+5*A_PtrSize), Ptr,icm, UInt,vFlags, UIntP,vCountCol) ;GetColumnCount
	return vCountCol
}

;========== I, TARAN, DID NOT WRITE THIS CODE, AND POSSIBLY DON'T USE IT ============

;mode: n (get name), c (get CLSID and property identifier), a (get all)
JEE_ICMGetColumns(icm, vSep="`n", vMode="n")
{
	vFlags := InStr(vMode, "a") ? 0x1 : 0x2
	DllCall(NumGet(NumGet(icm+0)+5*A_PtrSize), Ptr,icm, UInt,vFlags, UIntP,vCountCol) ;GetColumnCount
	vOutput := ""
	VarSetCapacity(vOutput, vCountCol*100*2)
	vOutput := ""
	;CM_ENUM_VISIBLE := 0x2 ;CM_ENUM_ALL := 0x1
	vArrayPROPERTYKEY := ""
	VarSetCapacity(vArrayPROPERTYKEY, vCountCol*20, 0)
	DllCall(NumGet(NumGet(icm+0)+6*A_PtrSize), Ptr,icm, UInt,vFlags, Ptr,&vArrayPROPERTYKEY, UInt,vCountCol) ;GetColumns
	Loop, % vCountCol
	{
		vOffset := (A_Index-1)*20
		if InStr(vMode, "c")
		{
			DllCall("ole32\StringFromCLSID", Ptr,&vArrayPROPERTYKEY+vOffset, PtrP,vAddrCLSID)
			vCLSID := StrGet(vAddrCLSID, "UTF-16")
			vNum := NumGet(vArrayPROPERTYKEY, vOffset+16, "UInt")
			vOutput .= vCLSID " " vNum
		}
		if InStr(vMode, "n")
		{
			if InStr(vMode, "c")
				vOutput .= "`t"
			DllCall("propsys\PSGetNameFromPropertyKey", Ptr,&vArrayPROPERTYKEY+vOffset, PtrP,vAddrName)
			vName := StrGet(vAddrName, "UTF-16")
			vOutput .= vName
		}
		vOutput .= vSep
	}
	vOutput := SubStr(vOutput, 1, -StrLen(vSep))
	return vOutput
}

;========== I, TARAN, DID NOT WRITE THIS CODE, AND POSSIBLY DON'T USE IT ============

JEE_ICMSetColumns(icm, vList, vSep="`n")
{
	DllCall(NumGet(NumGet(icm+0)+5*A_PtrSize), Ptr,icm, UInt,vFlags, UIntP,vCountCol) ;GetColumnCount
	vList := StrReplace(vList, vSep, vSep, vCountCol)
	vCountCol++
	vArrayPROPERTYKEY := ""
	VarSetCapacity(vArrayPROPERTYKEY, vCountCol*20, 0)
	Loop, Parse, vList, % vSep
	{
		vOffset := (A_Index-1)*20
		DllCall("propsys\PSGetPropertyKeyFromName", Str,A_LoopField, Ptr,&vArrayPROPERTYKEY+vOffset)
	}
	DllCall(NumGet(NumGet(icm+0)+7*A_PtrSize), Ptr,icm, Ptr,&vArrayPROPERTYKEY, UInt,vCountCol) ;SetColumns
	return
}

;========== I, TARAN, DID NOT WRITE THIS CODE, AND POSSIBLY DON'T USE IT ============

;not working (error 0x8000FFFF)
;is 'ideal' width, the autosize width?
JEE_ICMGetColumnWidth(icm, vName, ByRef vWidthIdeal="")
{
	VarSetCapacity(PROPERTYKEY, 20, 0)
	DllCall("propsys\PSGetPropertyKeyFromName", Ptr,&vName, Ptr,&PROPERTYKEY)
	VarSetCapacity(CM_COLUMNINFO, 184, 0)
	NumPut(184, CM_COLUMNINFO, 0, "UInt") ;cbSize
	;CM_MASK_WIDTH := 0x1 ;CM_MASK_IDEALWIDTH := 0x4
	NumPut(0x5, CM_COLUMNINFO, 4, "UInt") ;dwMask
	DllCall(NumGet(NumGet(icm+0)+4*A_PtrSize), Ptr,icm, Ptr,&PROPERTYKEY, Ptr,&CM_COLUMNINFO) ;GetColumnInfo
	vWidthIdeal := NumGet(CM_COLUMNINFO, 20, "UInt") ;uIdealWidth
	return NumGet(CM_COLUMNINFO, 12, "UInt") ;uWidth
}

;========== I, TARAN, DID NOT WRITE THIS CODE, AND POSSIBLY DON'T USE IT ============

JEE_ICMSetColumnWidth(icm, vName, vWidth)
{
	VarSetCapacity(PROPERTYKEY, 20, 0)
	DllCall("propsys\PSGetPropertyKeyFromName", Ptr,&vName, Ptr,&PROPERTYKEY)
	VarSetCapacity(CM_COLUMNINFO, 184, 0)
	NumPut(184, CM_COLUMNINFO, 0, "UInt") ;cbSize
	;CM_MASK_WIDTH := 0x1
	NumPut(0x1, CM_COLUMNINFO, 4, "UInt") ;dwMask
	NumPut(vWidth, CM_COLUMNINFO, 12, "UInt") ;dwMask
	DllCall(NumGet(NumGet(icm+0)+3*A_PtrSize), Ptr,icm, Ptr,&PROPERTYKEY, Ptr,&CM_COLUMNINFO) ;SetColumnInfo
}

;==================================================

;IFolderView2 interface (Windows)
;https://msdn.microsoft.com/en-us/library/windows/desktop/bb775541(v=vs.85).aspx
;methods (42): C:\Program Files (x86)\Windows Kits\8.1\Include\um\ShObjIdl.h

;========== I, TARAN, DID NOT WRITE THIS CODE, AND POSSIBLY DON'T USE IT ============

JEE_IFV2GetSortColumnCount(ifv2)
{
	DllCall(NumGet(NumGet(ifv2+0)+26*A_PtrSize), Ptr,ifv2, IntP,vCountCol) ;GetSortColumnCount
	return vCountCol
}

;========== I, TARAN, DID NOT WRITE THIS CODE, AND POSSIBLY DON'T USE IT ============

JEE_IFV2GetSortColumns(ifv2, vSep="`n", vMode="n")
{
	DllCall(NumGet(NumGet(ifv2+0)+26*A_PtrSize), Ptr,ifv2, IntP,vCountCol) ;GetSortColumnCount
	vOutput := ""
	vArraySORTCOLUMN := ""
	VarSetCapacity(vArraySORTCOLUMN, vCountCol*24, 0)
	DllCall(NumGet(NumGet(ifv2+0)+28*A_PtrSize), Ptr,ifv2, Ptr,&vArraySORTCOLUMN, Int,vCountCol) ;GetSortColumns
	Loop, % vCountCol
	{
		vOffset := (A_Index-1)*24
		if (vMode = "n")
		{
			DllCall("propsys\PSGetNameFromPropertyKey", Ptr,&vArraySORTCOLUMN+vOffset, PtrP,vAddrName)
			vName := StrGet(vAddrName, "UTF-16")
			;SORT_ASCENDING := 1 ;SORT_DESCENDING := -1
			vDirection := NumGet(vArraySORTCOLUMN, vOffset+20, "Int")
			vOutput .= vName " " vDirection vSep
		}
		else if (vMode = "c")
		{
			DllCall("ole32\StringFromCLSID", Ptr,&vArraySORTCOLUMN+vOffset, PtrP,vAddrCLSID)
			vCLSID := StrGet(vAddrCLSID, "UTF-16")
			vNum := NumGet(vArraySORTCOLUMN, vOffset+16, "UInt")
			vDirection := NumGet(vArraySORTCOLUMN, vOffset+20, "Int")
			vOutput .= vCLSID " " vNum " " vDirection vSep
		}
	}
	vOutput := SubStr(vOutput, 1, -StrLen(vSep))
	return vOutput
}

 

JEE_IFV2SetSortColumns(ifv2, vList, vSep="`n")
{
	vList := StrReplace(vList, vSep, vSep, vCountCol)
	vCountCol++
	vArraySORTCOLUMN := ""
	VarSetCapacity(vArraySORTCOLUMN, vCountCol*24, 0)
	Loop, Parse, vList, % vSep
	{
		vOffset := (A_Index-1)*24
		vPos := InStr(A_LoopField, " ", 0, -1)
		vName := SubStr(A_LoopField, 1, vPos-1)
		vDirection := SubStr(A_LoopField, vPos+1)
		DllCall("propsys\PSGetPropertyKeyFromName", Str,vName, Ptr,&vArraySORTCOLUMN+vOffset)
		;SORT_ASCENDING := 1 ;SORT_DESCENDING := -1
		NumPut(vDirection, vArraySORTCOLUMN, vOffset+20, "Int")
	}
	DllCall(NumGet(NumGet(ifv2+0)+27*A_PtrSize), Ptr,ifv2, Ptr,&vArraySORTCOLUMN, Int,vCountCol) ;SetSortColumns
}


sortByDate()
{
	WinGet, hWnd, ID, A
	oWin := JEE_ExpWinGetObj(hWnd)
	JEE_ExpGetInterfaces(oWin, isp, isb, isv, ifv2, icm)
	;above must load up the complex structures with black magic
	;clipboard:=JEE_IFV2GetSortColumns(ifv2)
	;System.DateModified -1
	;System.DateModified 1
	;;if RegExMatch(JEE_IFV2GetSortColumns(ifv2),"System.DateModified ?:-1")
	;regexesllwork but not straightforward
	curCol:=JEE_IFV2GetSortColumns(ifv2)
	;dont call it twice - maybe you wouldnt need to but im not seeing a superb way to avoid it below
	if InStr(curCol,"System.DateModified")
	{
		;test if it is ascending or descending and let's flip 'em
		If InStr(curCol,"-")
		{
			vList := "System.DateModified 1" 
		}
		;no alternate cases right?
		else {
			vList := "System.DateModified 1" 
		}
	}
	;no alternate cases right?
	else {
		vList := "System.DateModified 1"
	}
	JEE_IFV2SetSortColumns(ifv2, vList)
	isp := isb := isv := ifv2 := icm := ""
}

sortByDateOLD()
{
	WinGet, hWnd, ID, A
	oWin := JEE_ExpWinGetObj(hWnd)
	JEE_ExpGetInterfaces(oWin, isp, isb, isv, ifv2, icm)
	;above must load up the complex structures with black magic
	;clipboard:=JEE_IFV2GetSortColumns(ifv2)
	;System.DateModified -1
	;System.DateModified 1
	;;if RegExMatch(JEE_IFV2GetSortColumns(ifv2),"System.DateModified ?:-1")
	;regexesllwork but not straightforward
	curCol:=JEE_IFV2GetSortColumns(ifv2)
	;dont call it twice - maybe you wouldnt need to but im not seeing a superb way to avoid it below
	if InStr(curCol,"System.DateModified")
	{
		;test if it is ascending or descending and let's flip 'em
		If InStr(curCol,"-")
		{
			vList := "System.DateModified 1" ;Date modified ascending
		}
		;no alternate cases right?
		else {
			vList := "System.DateModified -1" ;Date modified descending
		}
	}
	;no alternate cases right?
	else {
		vList := "System.DateModified -1" ;Date modified descending should be default in my humble
	}
	JEE_IFV2SetSortColumns(ifv2, vList)
	isp := isb := isv := ifv2 := icm := ""
}

sortByDateDescending()
{
	WinGet, hWnd, ID, A
	oWin := JEE_ExpWinGetObj(hWnd)
	JEE_ExpGetInterfaces(oWin, isp, isb, isv, ifv2, icm)
	;above must load up the complex structures with black magic
	;clipboard:=JEE_IFV2GetSortColumns(ifv2)
	;System.DateModified -1
	;System.DateModified 1
	;;if RegExMatch(JEE_IFV2GetSortColumns(ifv2),"System.DateModified ?:-1")
	;regexesllwork but not straightforward
	curCol:=JEE_IFV2GetSortColumns(ifv2)
	;dont call it twice - maybe you wouldnt need to but im not seeing a superb way to avoid it below
	
	vList := "System.DateModified -1" ;Date modified descending 
	
	JEE_IFV2SetSortColumns(ifv2, vList)
	isp := isb := isv := ifv2 := icm := ""
}

sortByType()
{
	WinGet, hWnd, ID, A
	oWin := JEE_ExpWinGetObj(hWnd)
	JEE_ExpGetInterfaces(oWin, isp, isb, isv, ifv2, icm)
	curCol:=JEE_IFV2GetSortColumns(ifv2)
	if InStr(curCol,"System.ItemTypeText")
	{
		If InStr(curCol,"-")
		{
			vList := "System.ItemTypeText 1" ;Ascending
		}
		else {
			vList := "System.ItemTypeText -1" ;Descending
		}
	}
	else {
		vList := "System.ItemTypeText -1" ;Ascending default
	}
	JEE_IFV2SetSortColumns(ifv2, vList)
	isp := isb := isv := ifv2 := icm := ""
}

sortBySize()
{
	WinGet, hWnd, ID, A
	oWin := JEE_ExpWinGetObj(hWnd)
	JEE_ExpGetInterfaces(oWin, isp, isb, isv, ifv2, icm)
	curCol:=JEE_IFV2GetSortColumns(ifv2)
	if InStr(curCol,"System.Size")
	{
		If InStr(curCol,"-")
		{
			vList := "System.Size 1" ;Ascending
		}
		else {
			vList := "System.Size -1" ;Descending
		}
	}
	else {
		vList := "System.Size -1" ;Ascending default?  i may pick something else here in practice
	}
	JEE_IFV2SetSortColumns(ifv2, vList)
	isp := isb := isv := ifv2 := icm := ""
}

sortByName()
{
	WinGet, hWnd, ID, A
	oWin := JEE_ExpWinGetObj(hWnd)
	JEE_ExpGetInterfaces(oWin, isp, isb, isv, ifv2, icm)
	curCol:=JEE_IFV2GetSortColumns(ifv2)
	if InStr(curCol,"System.Name")
	{
		If InStr(curCol,"-")
		{
			vList := "System.Name 1" ;Ascending
			tooltip, ascending
		}
		else {
			vList := "System.Name -1" ;Descending
			tooltip, descending
		}
	}
	else {
		vList := "System.Name -1" ;Ascending default
		;tooltip, wahatever
	}
	JEE_IFV2SetSortColumns(ifv2, vList)
	isp := isb := isv := ifv2 := icm := ""
}

switchToExplorer()
{
	sleep 11 ;this is to avoid the stuck modifiers bug
	IfWinNotExist, ahk_class CabinetWClass
		Run, explorer.exe
		GroupAdd, taranexplorers, ahk_class CabinetWClass
	if WinActive("ahk_exe explorer.exe")
		GroupActivate, taranexplorers, r
	else
		WinActivate ahk_class CabinetWClass
}

closeAllExplorers()
{
WinClose,ahk_group taranexplorers
; i want to improve this so that the bottom (most recently active) explorer window does NOT close. IDK how to do that yet though.
; https://stackoverflow.com/questions/39601787/close-windows-explorer-window-with-auto-hotkey
; https://autohotkey.com/board/topic/88648-close-all-explorer-windows/
}

openApp(theClass, theEXE, theTitle := ""){

If !WinExist, %theClass%
	Run, % theEXE
if not WinActive(theClass)
	{
	WinActivate %theClass%
	;WinGetTitle, Title, A
	WinRestore %theTitle%
	} 
}

