;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                    ;
;               auWin                ;
;                                    ;
;     Copyright (C) 2022 dodaucy     ;
;  https://github.com/dodaucy/auWin  ;
;                                    ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


#AutoIt3Wrapper_Res_ProductName=auWin
#AutoIt3Wrapper_Res_Description=auWin is a program with which you can easily change attributes of windows and do other things with windows.
#AutoIt3Wrapper_Res_ProductVersion=1.0.0
#AutoIt3Wrapper_Res_LegalCopyright=Copyright (C) 2022 dodaucy
#AutoIt3Wrapper_Compression=0
#AutoIt3Wrapper_UseUpx=N


#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <ProgressConstants.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <MsgBoxConstants.au3>


Func ProcessReturnValue($value)
    If Not IsInt($value) Then
        Return "Success"
    EndIf
    If $value <> 0 Then
        Return "Success"
    Else
        Return "Failed"
    EndIf
EndFunc


#Region ### Create GUI ###

    ; Create GUI
    $gui = GUICreate("auWin", 525, 350)

    ; Set GUI in top
    WinSetOnTop($gui, "", 1)

    ; Create title/class input field
    $title_class_text = GUICtrlCreateLabel("title/class (optional):", 8, 10, 100, 17)
    $title_class_ctrl = GUICtrlCreateInput("", 104, 8, 241, 21)

    ; Create handle input field
    $handle_text = GUICtrlCreateLabel("handle (optional):", 8, 34, 82, 17)
    $handle_ctrl = GUICtrlCreateInput("", 104, 32, 241, 21)

    ; Create search mode radio
    $match_the_title_from_the_start = GUICtrlCreateRadio("Match the title from the start", 352, 8, 153, 17)
    GUICtrlSetState(-1, 1)
    $match_any_substring_in_the_title = GUICtrlCreateRadio("Match any substring in the title", 352, 32, 169, 17)
    $exact_title_match = GUICtrlCreateRadio("Exact title match", 352, 56, 105, 17)
    $advanced_mode = GUICtrlCreateRadio("Advanced mode", 352, 80, 105, 17)

    ; Create mode combo box
    $action_ctrl = GUICtrlCreateCombo("display", 8, 64, 97, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
    GUICtrlSetData(-1, "flash|close|kill|hide|show|minimize|maximize|restore|disable|enable|set on top|set not on top|set transparency|set title|move|get position|get text")

    ; Create start button
    $start = GUICtrlCreateButton("START", 8, 96, 97, 41)

    ; Create help button
    $window_titles_and_text = GUICtrlCreateButton("Window Titles and Text (Advanced)", 112, 64, 233, 33)

    ; Create progress bar
    $progress = GUICtrlCreateProgress(112, 104, 401, 33)

    ; Create output text box
    $display = GUICtrlCreateEdit("", 8, 144, 505, 193, BitOR($GUI_SS_DEFAULT_EDIT, $ES_READONLY))

    ; Show GUI
    GUISetState(@SW_SHOW)

#EndRegion


While 1

	Switch GUIGetMsg()

        ; Exit program
		Case $GUI_EVENT_CLOSE
			Exit

        ; Help for title match mode
        Case $window_titles_and_text
			ShellExecute("https://www.autoitscript.com/autoit3/docs/intro/windowsadvanced.htm")

		Case $start

            ; Set window title match mode
            Switch 1
                Case GUICtrlRead($match_the_title_from_the_start)
                    AutoItSetOption("WinTitleMatchMode", 1)
                Case GUICtrlRead($match_any_substring_in_the_title)
                    AutoItSetOption("WinTitleMatchMode", 2)
                Case GUICtrlRead($exact_title_match)
                    AutoItSetOption("WinTitleMatchMode", 3)
                Case GUICtrlRead($advanced_mode)
                    AutoItSetOption("WinTitleMatchMode", 4)
            EndSwitch

            ; Read input fields
            $action = GUICtrlRead($action_ctrl)
			$title_class = GUICtrlRead($title_class_ctrl)
			$handle = GUICtrlRead($handle_ctrl)
            $handle_ptr = Ptr($handle)
            If $title_class <> "" And $handle <> "" Then
                WinSetOnTop($gui, "", 0)
                MsgBox($MB_ICONERROR, "ERROR", "Please enter title, class, handle or nothing")
                WinSetOnTop($gui, "", 1)
                ContinueLoop
            EndIf
			If $handle <> "" And $handle_ptr = "" Then
                WinSetOnTop($gui, "", 0)
				MsgBox($MB_ICONERROR, "ERROR", "Invalid handle")
				WinSetOnTop($gui, "", 1)
				ContinueLoop
            EndIf

            ; Get window list
			If $title_class = "" And $handle_ptr = "" Then
                ; Get all windows
                $win_list = WinList()
			ElseIf $title_class <> "" Then
                ; Get windows with title/class
                $win_list = WinList($title_class)
			ElseIf $handle_ptr <> "" Then
                ; Get window with handle
				If WinExists($handle_ptr) Then
                    Local $win_list[2][2] = [[1, ""], [WinGetTitle($handle_ptr), $handle_ptr]]
				Else
					Local $win_list[1][2] = [[0, ""]]
				EndIf
			EndIf

            ; Ask for transparency if required
            If $action = "set transparency" Then
                WinSetOnTop($gui, "", 0)
                $trans = InputBox("transparency", "Set the transparency to a value between 0 and 255", "255")
                WinSetOnTop($gui, "", 1)
                If $trans = "" Then ContinueLoop
            EndIf

            ; Ask for title if required
            If $action = "set title" Then
                WinSetOnTop($gui, "", 0)
                $new_title = InputBox("title", "Set the title")
                WinSetOnTop($gui, "", 1)
                If $new_title = "" Then ContinueLoop
            EndIf

            ; Ask for position and size if required
            If $action = "move" Then
                WinSetOnTop($gui, "", 0)
                $x = InputBox("X", "X coordinate to move to", "0")
                If $x = "" Then
                    WinSetOnTop($gui, "", 1)
                    ContinueLoop
                EndIf
                $y = InputBox("Y", "Y coordinate to move to", "0")
                If $y = "" Then
                    WinSetOnTop($gui, "", 1)
                    ContinueLoop
                EndIf
                If MsgBox($MB_YESNO, "size", "Would you like to specify a size?") = $IDYES Then
                    $width = InputBox("width", "Width", "0")
                    If $width = "" Then
                        WinSetOnTop($gui, "", 1)
                        ContinueLoop
                    EndIf
                    $height = InputBox("height", "Height", "0")
                    If $height = "" Then
                        WinSetOnTop($gui, "", 1)
                        ContinueLoop
                    EndIf
                    $resize = True
                Else
                    $resize = False
                EndIf
                WinSetOnTop($gui, "", 1)
            EndIf

            ; Clear GUI
			GUICtrlSetData($display, "")
			GUICtrlSetData($progress, 0)

            ; Cycle through all found windows
            For $i = 1 To $win_list[0][0] Step 1

                ; Get handle of window
			    $window_handle = $win_list[$i][1]

                ; Ignore itself
			    If $window_handle <> $gui Then

                    ; Run command
					Switch $action
                        Case "display"
                            $output_text = ""
						Case "flash"
							WinFlash($window_handle)
                            $output_text = "Flashed"
						Case "close"
							$output_text = ProcessReturnValue(WinClose($window_handle))
						Case "kill"
                            $output_text = ProcessReturnValue(WinKill($window_handle))
						Case "hide"
							$output_text = ProcessReturnValue(WinSetState($window_handle, "", @SW_HIDE))
						Case "show"
							$output_text = ProcessReturnValue(WinSetState($window_handle, "", @SW_SHOW))
						Case "minimize"
							$output_text = ProcessReturnValue(WinSetState($window_handle, "", @SW_MINIMIZE))
						Case "maximize"
							$output_text = ProcessReturnValue(WinSetState($window_handle, "", @SW_MAXIMIZE))
						Case "restore"
							$output_text = ProcessReturnValue(WinSetState($window_handle, "", @SW_RESTORE))
						Case "disable"
							$output_text = ProcessReturnValue(WinSetState($window_handle, "", @SW_DISABLE))
						Case "enable"
							$output_text = ProcessReturnValue(WinSetState($window_handle, "", @SW_ENABLE))
						Case "set on top"
							$output_text = ProcessReturnValue(WinSetOnTop($window_handle, "", 1))
						Case "set not on top"
							$output_text = ProcessReturnValue(WinSetOnTop($window_handle, "", 0))
						Case "set transparency"
							$output_text = ProcessReturnValue(WinSetTrans($window_handle, "", $trans))
						Case "set title"
							$output_text = ProcessReturnValue(WinSetTitle($window_handle, "", $new_title))
						Case "move"
							If $resize Then
								$output_text = ProcessReturnValue(WinMove($window_handle, "", $x, $y, $width, $height))
							Else
								$output_text = ProcessReturnValue(WinMove($window_handle, "", $x, $y))
							EndIf
						Case "get position"
							$pos = WinGetPos($window_handle)
							$output_text = "X: " & $pos[0] & " Y: " & $pos[1] & " Width: " & $pos[2] & " Height: " & $pos[3]
						Case "get text"
							$output_text = WinGetText($window_handle)
                            If $output_text <> "" Then
                                $output_text = @CRLF & $output_text
                            EndIf
					EndSwitch

                    ; Append result to output text box
                    If $output_text <> "" Then
                        $output_text = " " & $output_text
                    EndIf
					GUICtrlSetData($display, "[" & $window_handle & "] (" & $win_list[$i][0] & ")" & $output_text & @CRLF & GUICtrlRead($display))

				EndIf

                ; Update progress bar
				GUICtrlSetData($progress, $i / $win_list[0][0] * 100)

			Next

            ; Set progress bar to 100% in case it wasn't already
			GUICtrlSetData($progress, 100)

	EndSwitch

WEnd
