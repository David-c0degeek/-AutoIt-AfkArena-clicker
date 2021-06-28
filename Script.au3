#include "_ImageSearch_UDF.au3"
#include "_ImageSearch_Tool.au3"
#include <Array.au3>
#include <File.au3>
#RequireAdmin

HotKeySet("{Esc}", "_Exit")
Func _Exit()
	Exit 0
EndFunc   ;==>_Exit

Func _MyDebug($sMessage, $iError = @error, $iExtended = @extended)
	If $iError Or $iExtended Then
		$sMessage &= '[ @error = ' & $iError & ' @extended = ' & $iExtended & ' ]'
	EndIf
	DllCall("kernel32.dll", "none", "OutputDebugString", "str", $sMessage)
	Return SetError($iError, $iExtended, '')
EndFunc   ;==>_MyDebug

Func _resize()
    $hWnd = WinGetHandle("BlueStacks")
;~   $pos = WinGetPos($hWnd)
;~	ConsoleWrite("Pos: " & $pos)
;~	ConsoleWrite(" X: " & $pos[0])
;~	ConsoleWrite(" Y: " & $pos[1])
    WinMove($hWnd, '', 1337, 132, 661, 1107)
;~  _WinSetClientPos($hWnd, "", 800, 600, $pos[0], $pos[1])
;~  _WinAPI_MoveWindow($hWnd, $pos[0], $pos[1], 800, 600)
;~  _WinAPI_SetWindowPos($hWnd, $HWND_NOTOPMOST, $pos[0], $pos[1], 800, 600, $SWP_NOMOVE)
    Sleep(500)
EndFunc

Global Enum $kingsTower, $combined, $campaign
Global $runType = $campaign

Global $_baseDir = @ScriptDir & "\Images\"
Global $_kingsTower = $_baseDir & "KingsTower\"
Global $_combined = $_baseDir & "Combined\"

Work()

Func Work()
	Local $dir

	Switch $runType
		Case $campaign
			$dir = $_baseDir
		Case $kingsTower
			$dir = $_kingsTower
		Case $combined
			$dir = $_combined
		Case Else
			$dir = $_baseDir
	EndSwitch

	#ConsoleWrite("Dir: " & $dir)

	Local $images = _FileListToArray($dir, "*")

	While 1
		ToolTip('(Press ESC to EXIT) Running ...', 1, 1)
		_resize()
		Local $i, $result, $x, $y, $name

		For $i = 1 To $images[0]
			$result = _ImageSearch($dir & $images[$i])

			#ConsoleWrite($images[$i])

			If $result[0] = 1 Then

				$x = $result[1]
				$y = $result[2]
				$name = $images[$i]

				If StringInStr($name, "Offset_") Then
					If StringInStr($name, "Right_") Then
						$x = $x + 250
					Else
						$x = $x - 150
					EndIf

					If StringInStr($name, "Down_") Then
						$y = $y + 250
					EndIf

					If StringInStr($name, "Up_") Then
						$y = $y - 70
					EndIf

					If StringInStr($name, "Left_") Then
						$x = $x - 220
					EndIf
				EndIf

				_resize()
				MouseClick("left", $x, $y)

				Sleep(1000)
			EndIf
		Next

		Sleep(1000)
	WEnd

EndFunc   ;==>Work
