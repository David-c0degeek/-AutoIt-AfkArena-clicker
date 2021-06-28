#include "_ImageSearch_UDF.au3"
#include "_ImageSearch_Tool.au3"
#include <Array.au3>
#include <File.au3>
#RequireAdmin

HotKeySet("{ESC}", _Exit)
Global $_baseDir = @ScriptDir & "\Images\"

Global $windowX = 1875
Global $windowY = 239
Global $windowWidth = 661
Global $windowHeight = 1107

Work()

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
	WinMove($hWnd, '', $windowX, $windowY, $windowWidth, $windowHeight)
	Sleep(500)
EndFunc   ;==>_resize

Func Work()

	Local $images = _FileListToArray($_baseDir, "*")

	Local $searchAreaX	= $windowX
	Local $searchAreaY	= $windowY
	Local $searchAreaX1	= $windowX + $windowWidth
	Local $searchAreaY1	= $windowY + $windowHeight

	While 1
		ToolTip('(Press ESC to EXIT) Running ...', 1, 1)
		_resize()
		Local $i, $result, $x, $y, $name

		For $i = 1 To $images[0]

			Local $imagePath = $_baseDir & $images[$i]

			$result = _ImageSearch_Area($imagePath, $searchAreaX, $searchAreaY, $searchAreaX1, $searchAreaY1, 5, True)

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

			Sleep(100)
		Next

		Sleep(1000)
	WEnd

EndFunc   ;==>Work
