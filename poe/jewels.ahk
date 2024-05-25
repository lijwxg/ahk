#SingleInstance Force
; HotIfWinActive  "Path of Exile"

SetMouseDelay 20
SetWorkingDir A_ScriptDir
SendMode "Input"

ConfigINI := A_ScriptDir  "\Config.ini"
test_txt := A_ScriptDir  "\test.txt"

if !FileExist(ConfigINI)
{
	MsgBox "Please create ConfigINI.ini and add modified under [modified]"
	return 
}

rel_x := IniRead(ConfigINI, "relative", "x")
rel_y := IniRead(ConfigINI, "relative", "y")
out_y := IniRead(ConfigINI, "relative", "out_y")

get_jewels(){
	return IniRead(ConfigINI, "jewels")
}

get_xy(section){
	x := IniRead(ConfigINI, section, "x")
	y := IniRead(ConfigINI, section, "y")
	return x "," y
}

test_click(xy){
	xy_split := StrSplit(xy,",")
	x := xy_split[1]
	y := xy_split[2]
}

; right click function, need position: x,y
r_click(xy){
	xy_split := StrSplit(xy,",")
	x := xy_split[1]
	y := xy_split[2]
	Sleep 100
	BlockInput True
	MouseGetPos &xx, &yy
	MouseMove x, y, 10
	Sleep 250
	Click "Right"
	MouseMove xx, yy, 10
	Sleep 300
	Click
	BlockInput False
}

zengfu(){
	zengfu_xy := get_xy("zengfu")
	r_click(zengfu_xy)
}

gaizao(){
	gaizao_xy := get_xy("gaizao")
	r_click(gaizao_xy)
}

jewels(){
	Sleep 500
	; Optional: Clear the clipboard
	Clipboard := ""
	; Press Ctrl+C to copy
	Send "{Ctrl down}c{Ctrl up}"
	Sleep 300 ; Wait for the clipboard to update (adjust if needed)

	; Read the clipboard
	Clipboard := A_Clipboard
	;MsgBox  Clipboard

	; Clipboard := FileRead(test_txt)
	Array := StrSplit(Clipboard, "--------")
	key_content := Trim(Array[5],"`r`n")
	; Loop through each modified from the INI file
	len := 0
	Loop parse, key_content, "`n"
	{
		key_field := A_LoopField
		match := ""
		Loop parse, get_jewels(), "`n"{
			jewels_field := A_LoopField
			IsFound := RegExMatch(key_field, jewels_field)
			if(IsFound)
			{
				match := 1
			}
		}
		if (match != 1){
			return 0
		}
		else{
			len += 1
		}
	}
	return len
}


!1::
{
	Loop 500
	{
		len := jewels()
		if (len == 3){
			MouseGetPos &xx, &yy
			if (yy+rel_y > out_y){
				MsgBox "finished"
				break
			}
			MouseMove 0, rel_y, 10, "R"
		}
		else if (len != 0){
			; MsgBox "zengfu"
			zengfu()
		}
		else{
			; MsgBox "gaizao"
			gaizao()
		}


	}
}

+F11::
{
	MouseGetPos &xx, &yy
	IniWrite xx	, ConfigINI, "gaizao", "x"
	IniWrite yy	, ConfigINI, "gaizao", "y"
	return
}

+F12::
{
	MouseGetPos &xx, &yy
	IniWrite xx	, ConfigINI, "zengfu", "x"
	IniWrite yy	, ConfigINI, "zengfu", "y"
	return
}

!q::
{
	Reload
}
