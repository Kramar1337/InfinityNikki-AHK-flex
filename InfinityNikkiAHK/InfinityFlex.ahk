/*
Ahk для Infinity Nikki

infinitynikki1205
GIFTTONIKKI
GIFTFROMMOMO
BDAYSURPRISE
nikkihappybirthday2024
NIKKITHEBEST
QUACKQUACK


Изменения: 05.12.2024
 - Фикс Фастлут
 - Скип диалогов
 - Асистер Рыбалки

Изменения: 30.11.2024
 - Фастлут
 - Скип диалогов
 - Бинд на карту

*/
#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%
#SingleInstance force
DetectHiddenWindows, On
DetectHiddenText, On
CoordMode Mouse, Screen
CoordMode Pixel, Screen
SetTitleMatchMode, 2
Process, Priority,, High
Setbatchlines,-1
SetKeyDelay,-1, -1
SetControlDelay, -1
SetMouseDelay, -1
SetWinDelay,-1
Menu,Tray, Icon, data\icon.ico, ,1

CommandLine := DllCall("GetCommandLine", "Str")
If !(A_IsAdmin || RegExMatch(CommandLine, " /restart(?!\S)")) {
	Try {
		If (A_IsCompiled) {
			Run *RunAs "%A_ScriptFullPath%" /restart
		} Else {
			Run *RunAs "%A_AhkPath%" /restart "%A_ScriptFullPath%"
		}
	}
	ExitApp
}
Menu,Tray, Icon, %A_ScriptDir%\data\icon.ico
Menu,Tray, NoStandard
Menu,Tray, DeleteAll
Menu,Tray, add, Import cfg, UpCfg
Menu,Tray, Icon, Import cfg, shell32.dll,264, 16
Menu,Tray, add
Menu,Tray, add, Reload, MetkaMenu2
Menu,Tray, Icon, Reload, shell32.dll, 239, 16
Menu,Tray, add, Exit, MetkaMenu1
Menu,Tray, Icon, Exit, shell32.dll,28, 16

;=============================Получить список "GroupNameMap.txt" и распределить
FileRead, GroupNameMapVar, %A_ScriptDir%\data\GroupNameMap.txt
Loop, parse, GroupNameMapVar, `n, `r
{
	VarLoop1:=A_LoopField
	VarLoop1 := RegExReplace(VarLoop1, "mi);.*", "")
	if (VarLoop1 != "")
	GroupAdd, GroupNameMap, %VarLoop1%
}



IniRead, WindowFocus, data\Config.ini, Settings, WindowFocus
IniRead, SkipNPCLockMode, data\Config.ini, Settings, SkipNPCLockMode
; IniRead, FastlytFastMode, data\Config.ini, Settings, FastlytFastMode
IniRead, MapRunUrl, data\Config.ini, Settings, MapRunUrl


IniRead, key_fishing, data\Config.ini, Settings, key_fishing
IniRead, key_SkipNPC, data\Config.ini, Settings, key_SkipNPC
IniRead, key_Fastlyt, data\Config.ini, Settings, key_Fastlyt
IniRead, key_Map, data\Config.ini, Settings, key_Map

IniRead, key_EndExitapp, data\Config.ini, Settings, key_EndExitapp
IniRead, key_Reload, data\Config.ini, Settings, key_Reload

IniRead, Checkbox_Fishing, data\Config.ini, Settings, Checkbox_Fishing
IniRead, Checkbox_SkipNPC, data\Config.ini, Settings, Checkbox_SkipNPC
IniRead, Checkbox_Fastlyt, data\Config.ini, Settings, Checkbox_Fastlyt
IniRead, Checkbox_Map, data\Config.ini, Settings, Checkbox_Map
IniRead, Checkbox_Reload, data\Config.ini, Settings, Checkbox_Reload


if Checkbox_Fishing
	Hotkey, *~$%key_fishing%, Label_fishing, on
if Checkbox_SkipNPC
	Hotkey, *~$%key_SkipNPC%, Label_SkipNPC, on
if Checkbox_Fastlyt
	Hotkey, *~$%key_Fastlyt%, Label_Fastlyt, on
if Checkbox_Map
	Hotkey, %key_Map%, Label_Map, on
if Checkbox_Reload
	Hotkey, *~$%key_Reload%, MetkaMenu2, on

Hotkey, *~$%key_EndExitapp%, MetkaMenu1, on
return


;============================Карта
Label_Map:
Sleep 1
Keywait %Key_Map%
IfWinActive, %WindowFocus%
{
	IfWinNotExist, ahk_group GroupNameMap
	{
		Run, %MapRunUrl%
		WinWait, ahk_group GroupNameMap, , 3
	}
	WinActivate ahk_group GroupNameMap
}
Else
{
	WinActivate %WindowFocus%
}
Return


;============================Спам RButon
Label_fishing:
Sleep 50
IfWinNotActive, %WindowFocus%
	Return
if FuncCursorVisible()
	Return
Loop
{
	GetKeyState, SpaceVar, %key_fishing%, P
	If SpaceVar = U
		break 
	SendInput {Blind}{vk2 down} 	;F
	Sleep 1
	SendInput {Blind}{vk2 up} 	;F
	FuncRandomSleep()
}
return

;============================Фастлут
Label_fastlyt:
Sleep 50
IfWinNotActive, %WindowFocus%
	Return
if FuncCursorVisible()
	Return
Loop
{
	GetKeyState, SpaceVar, %key_Fastlyt%, P
	If SpaceVar = U
		break 
	SendInput {Blind}{vk46 down} 	;F
	Sleep 1
	SendInput {Blind}{vk46 up} 	;F
	FuncRandomSleep()
}
return


;============================Скип диалогов NPC
Label_SkipNPC:
Sleep 150

xSkip:=round(A_ScreenWidth * (1830 / 2560))
ySkip:=round(A_ScreenHeight * (1020 / 1440))

; xSkip2:=round(A_ScreenWidth * (155 / 2560))
; ySkip2:=round(A_ScreenHeight * (90 / 1440))

; xSkip3:=round(A_ScreenWidth * (1125 / 2560))
; ySkip3:=round(A_ScreenHeight * (800 / 1440))

; xSkip4:=round(A_ScreenWidth * (1722 / 2560))
; ySkip4:=round(A_ScreenHeight * (900 / 1440))

; xSkip5:=round(A_ScreenWidth * (1700 / 2560))
; ySkip5:=round(A_ScreenHeight * (1000 / 1440))

IfWinNotActive, %WindowFocus%
	Return
if !FuncCursorVisible()
	Return
if SkipNPCLockMode
{
	Keywait %key_SkipNPC%

	Toggle1SkipNPC := !Toggle1SkipNPC
	if (Toggle1SkipNPC)
	{
	  SetTimer, TimerNpcSkip, on
	  Tooltip Skip NPC: Loop,round(A_ScreenWidth * .5 - 50),0,2
	}
	Else
	{
	  SetTimer, TimerNpcSkip, off
	  Tooltip,,0,0,2
	}
}
Else
{
	Loop
	{
		GetKeyState, SpaceVar, %key_SkipNPC%, P
		If SpaceVar = U
			break
		Sleep 100
		FuncRandomSleep()
		Click %xSkip% %ySkip%
		FuncRandomSleep()
		
		; Click %xSkip2% %ySkip2%
		; FuncRandomSleep()
		; Click %xSkip3% %ySkip3%
		; FuncRandomSleep()
		; Click %xSkip4% %ySkip4%
		; FuncRandomSleep()
		; Click %xSkip5% %ySkip5%
	}
}
Return
;============================SetTimer Скип диалогов
TimerNpcSkip:
Sleep 100
if ((!FuncCursorVisible() || !WinActive(WindowFocus)) || (GetKeyVK(A_PriorKey) != GetKeyVK(key_SkipNPC)))
{
	Toggle1SkipNPC := !Toggle1SkipNPC
	SetTimer, TimerNpcSkip, off
	Tooltip,,0,0,2
}
FuncRandomSleep()
Click %xSkip% %ySkip%

; FuncRandomSleep()
; Click %xSkip2% %ySkip2%
; FuncRandomSleep()
; Click %xSkip3% %ySkip3%
; FuncRandomSleep()
; Click %xSkip4% %ySkip4%
; FuncRandomSleep()
; Click %xSkip5% %ySkip5%
Return


UpCfg:
    FileSelectFile, selectedFile, 3, %A_ScriptDir%, Выберите файл config.ini, INI (*.ini)
    if selectedFile =
        return
    if (FileExist(selectedFile) && RegExMatch(selectedFile, "config\.ini$") = 0)
    {
        MsgBox,,, Выбранный файл не является "config.ini",1
        return
    }
    newFilePath := A_ScriptDir "\data\config.ini"
    IniRead, sections, %selectedFile%, ,
    Loop, Parse, sections, `n
    {
        section := A_LoopField
        IniRead, keys, %selectedFile%, %section%
        Loop, Parse, keys, `n
        {
            keyArray := StrSplit(A_LoopField, "=")
            if (keyArray.MaxIndex() = 2) ; Проверить, была ли строка успешно разделена
            {
                paramName := keyArray[1]
                paramValue := keyArray[2]
                IniWrite, %paramValue%, %newFilePath%, %section%, %paramName%
            }
            else
            {
                MsgBox,,, Неправильный формат строки в файле: %selectedFile%
                continue
            }
        }
    }
    MsgBox,,, Настройки импортированы,1
return


;============================Функция: есть курсор мышки - 1, нет курсора - 0
FuncCursorVisible()
{
	StructSize1337 := A_PtrSize + 16
	VarSetCapacity(InfoStruct1337, StructSize1337)
	NumPut(StructSize1337, InfoStruct1337)
	DllCall("GetCursorInfo", UInt, &InfoStruct1337)
	Result1337 := NumGet(InfoStruct1337, 8)
	if (Result1337 <> 0)
		CursorVisible := 1
	Else
		CursorVisible := 0
	Return CursorVisible
}
;============================Функция рандома Sleep
FuncRandomSleep()
{
	Random, ScRandomSleep, 15, 40
	Sleep %ScRandomSleep%
}
; Функция для генерации случайного имени
GenerateRandomName(length) {
    chars := "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
    name := ""
    Loop, %length%
    {
        Random, index, 1, StrLen(chars)
        name .= SubStr(chars, index, 1)
    }
    return name
}


MetkaMenu3:
Run, notepad.exe "%A_ScriptFullPath%"
return

*~$Home::
MetkaMenu2:
Reload
return

*~$End::
MetkaMenu1:
ExitApp
return
