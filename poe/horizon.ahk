#IfWinActive  Path of Exile
#NoEnv 
#SingleInstance , Force
SetMouseDelay 20
SetWorkingDir %A_ScriptDir% 
SendMode, Input
ConfigINI=%A_scriptdir%\Config.ini
ifnotexist,%ConfigINI%
{
	IniWrite, 0	, %ConfigINI%, HorizonPos, xx
	IniWrite, 0	, %ConfigINI%, HorizonPos, yy
}
; Read favorite maps from INI file
MapsINI=%A_scriptdir%\horizon_maps.ini
ifnotexist,%MapsINI%
{
	MsgBox, Please create Maps.ini and add maps under [Maps]
}
IniRead, Maps, Maps.ini, Maps
return


!1::
; Press Ctrl+C to copy
Send, ^c
Sleep, 50 ; Wait for the clipboard to update (adjust if needed)

; Read the clipboard
Clipboard := ClipboardAll

; Loop through each map from the INI file
Found := false
Loop, Parse, Maps, `n
{
    MapToCheck := A_LoopField
    IsFound :=  RegExMatch(Clipboard, "m)^" MapToCheck)
    if (IsFound) {
    	Send, ^{Click}
    	Found := true
    	break
    }    
}

if (!Found)
{
 	BlockInput, MouseMove
	MouseGetPos xx, yy
	rCordXX = %xx%
	rCordYY = %yy%    
	IniRead, CordXX, Config.ini, HorizonPos, xx
	IniRead, CordYY, Config.ini, HorizonPos, yy
	MouseMove, CordXX , CordYY , 0
	Sleep 100		
	Click, Right
	MouseMove, rCordXX , rCordYY , 0
	Sleep 100
	Click
	BlockInput, MouseMoveOff		
}

; Optional: Clear the clipboard
Clipboard := ""
return




+F12::
	MouseGetPos xx, yy
	IniWrite,%xx%	,	%ConfigINI%, HorizonPos, xx
	IniWrite,%yy%	,	%ConfigINI%, HorizonPos, yy
return