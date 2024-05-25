jewels := A_ScriptDir  "\jewels.ini"
if !FileExist(jewels)
{
	MsgBox "Please create jewels.ini and add modified under [modified]"
	return 
}
MsgBox  jewels
modified := IniRead(jewels, "modified")
MsgBox  modified

; Read the clipboard
Clipboard:= "召唤生物附加 基础物理伤害 (fractured) 召唤生物的攻击速度加快"
MsgBox  Clipboard

; Loop through each modified from the INI file
len := 0
Loop parse, modified, "`n"
{
	MsgBox A_LoopField
    ModifiedToCheck := A_LoopField
    IsFound :=  RegExMatch(Clipboard, ModifiedToCheck)
    if (IsFound) {
		len += 1
    }
}

MsgBox len

if (len == 2)
{
 	MsgBox "success"
}


; Optional: Clear the clipboard
Clipboard := ""
return



