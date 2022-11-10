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
#include <WinAPI.au3>


#Region ### Create GUI ###

    $auWin = GUICreate("auWin", 522, 522)
    WinSetOnTop($auWin, "", 1)

    $group_search_for_windows = GUICtrlCreateGroup("Search for windows", 8, 8, 505, 113)

    $label_title_class = GUICtrlCreateLabel("Title / Class (optional):", 16, 34, 127, 17)
    $input_title_class = GUICtrlCreateInput("", 144, 32, 193, 21)
    $handle_input_title_class = GUICtrlGetHandle($input_title_class)
    $label_window_handle = GUICtrlCreateLabel("Window handle (optional):", 16, 66, 127, 17)
    $input_window_handle = GUICtrlCreateInput("", 144, 64, 193, 21)
    $handle_input_window_handle = GUICtrlGetHandle($input_window_handle)

    $label_fields_info = GUICtrlCreateLabel("Please fill out a maximum of one field!", 16, 98, 323, 17, $SS_CENTER)

    $radio_win_title_match_mode_1 = GUICtrlCreateRadio("Match the title from the start", 344, 23, 161, 17)
    GUICtrlSetState(-1, BitOR($GUI_CHECKED, $GUI_DISABLE))
    $radio_win_title_match_mode_2 = GUICtrlCreateRadio("Match any substring in the title", 344, 47, 161, 17)
    GUICtrlSetState(-1, $GUI_DISABLE)
    $radio_win_title_match_mode_3 = GUICtrlCreateRadio("Exact title match", 344, 71, 161, 17)
    GUICtrlSetState(-1, $GUI_DISABLE)
    $radio_win_title_match_mode_4 = GUICtrlCreateRadio("Advanced mode", 344, 95, 161, 17)
    GUICtrlSetState(-1, $GUI_DISABLE)

    $group_action = GUICtrlCreateGroup("Action", 8, 128, 505, 105)

    $combo_action = GUICtrlCreateCombo("Display", 24, 152, 145, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
    GUICtrlSetData(-1, "Display handle|Flash|Send close signal|Send kill signal|Hide|Show|Minimize|Maximize|Restore|Disable|Enable|Set on top|Set not on top|Set transparency|Set title|Move|Resize|Display position and size|Display text")
    $handle_combo_action = GUICtrlGetHandle($combo_action)

    $button_start = GUICtrlCreateButton("Start", 24, 184, 147, 33)

    $label_more_infos = GUICtrlCreateLabel("", 192, 154, 299, 17, $SS_CENTER)
    GUICtrlSetState(-1, $GUI_HIDE)

    $label_x = GUICtrlCreateLabel("X:", 184, 186, 52, 17, $SS_CENTER)
    GUICtrlSetState(-1, $GUI_HIDE)
    $input_x = GUICtrlCreateInput("0", 240, 184, 89, 21)
    GUICtrlSetState(-1, $GUI_HIDE)
    $label_y = GUICtrlCreateLabel("Y:", 352, 186, 53, 17, $SS_CENTER)
    GUICtrlSetState(-1, $GUI_HIDE)
    $input_y = GUICtrlCreateInput("0", 408, 184, 89, 21)
    GUICtrlSetState(-1, $GUI_HIDE)

    $label_width = GUICtrlCreateLabel("Width:", 184, 186, 52, 17, $SS_CENTER)
    GUICtrlSetState(-1, $GUI_HIDE)
    $input_width = GUICtrlCreateInput("0", 240, 184, 89, 21)
    GUICtrlSetState(-1, $GUI_HIDE)
    $label_height = GUICtrlCreateLabel("Height:", 352, 186, 53, 17, $SS_CENTER)
    GUICtrlSetState(-1, $GUI_HIDE)
    $input_height = GUICtrlCreateInput("0", 408, 184, 89, 21)
    GUICtrlSetState(-1, $GUI_HIDE)

    $input_one_line = GUICtrlCreateInput("", 184, 184, 313, 21)
    GUICtrlSetState(-1, $GUI_HIDE)

    $label_invisible = GUICtrlCreateLabel("Invisible", 184, 186, 50, 17, $SS_CENTER)
    GUICtrlSetState(-1, $GUI_HIDE)
    $label_visible = GUICtrlCreateLabel("Visible", 448, 186, 50, 17, $SS_CENTER)
    GUICtrlSetState(-1, $GUI_HIDE)
    $slider_trans = GUICtrlCreateSlider(240, 184, 206, 37)
    GUICtrlSetLimit(-1, 255, 0)
    GUICtrlSetData(-1, 255)
    GUICtrlSetState(-1, $GUI_HIDE)
    $handle_slider_trans = GUICtrlGetHandle($slider_trans)

    $progress = GUICtrlCreateProgress(8, 240, 505, 33)

    $edit_display = GUICtrlCreateEdit("", 8, 280, 505, 169, BitOR($GUI_SS_DEFAULT_EDIT, $ES_READONLY))

    $checkbox_self_protect = GUICtrlCreateCheckbox("Exclude own process (PID " & @AutoItPID & ")", 8, 456, 249, 25)
    GUICtrlSetState(-1, $GUI_CHECKED)
    $handle_checkbox_self_protect = GUICtrlGetHandle($checkbox_self_protect)
    $checkbox_set_self_on_top = GUICtrlCreateCheckbox("Set self on top", 264, 456, 249, 25)
    GUICtrlSetState(-1, $GUI_CHECKED)
    $handle_checkbox_set_self_on_top = GUICtrlGetHandle($checkbox_set_self_on_top)

    $button_introduction = GUICtrlCreateButton("Help / Introduction", 8, 488, 249, 25)
    $button_issue = GUICtrlCreateButton("Give feedback / Report bugs / Ask a question", 264, 488, 249, 25)

    GUIRegisterMsg($WM_COMMAND, "WM_COMMAND")
    GUIRegisterMsg($WM_HSCROLL, "WM_HSCROLL")
    GUISetState(@SW_SHOW)

#EndRegion


Global $self_protect = True

Global $over_two_fields = False
Global $invalid_handle = False


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


Func UpdateStartButton()
    If $over_two_fields Or $invalid_handle Then
        GUICtrlSetState($button_start, $GUI_DISABLE)
    Else
        GUICtrlSetState($button_start, $GUI_ENABLE)
    EndIf
EndFunc


Func UpdateTransparencyLabel()
    GUICtrlSetData($label_more_infos, "Transparency: (" & GUICtrlRead($slider_trans) & ")")
EndFunc


Func WM_COMMAND($hWnd, $Msg, $wParam, $lParam)
    $notify_code = _WinAPI_HiWord($wParam)
    $ctrl_id = _WinAPI_LoWord($wParam)
    Switch $lParam
        Case $handle_input_title_class, $handle_input_window_handle
            If $notify_code = $EN_CHANGE Then
                $title_class_data = GUICtrlRead($input_title_class)
                $window_handle_data = GUICtrlRead($input_window_handle)
                Switch $lParam
                    Case $handle_input_title_class
                        If $title_class_data == "" Then
                            GUICtrlSetState($radio_win_title_match_mode_1, $GUI_DISABLE)
                            GUICtrlSetState($radio_win_title_match_mode_2, $GUI_DISABLE)
                            GUICtrlSetState($radio_win_title_match_mode_3, $GUI_DISABLE)
                            GUICtrlSetState($radio_win_title_match_mode_4, $GUI_DISABLE)
                        Else
                            GUICtrlSetState($radio_win_title_match_mode_1, $GUI_ENABLE)
                            GUICtrlSetState($radio_win_title_match_mode_2, $GUI_ENABLE)
                            GUICtrlSetState($radio_win_title_match_mode_3, $GUI_ENABLE)
                            GUICtrlSetState($radio_win_title_match_mode_4, $GUI_ENABLE)
                        EndIf
                    Case $handle_input_window_handle
                        If $window_handle_data <> "" And Ptr($window_handle_data) = 0 Then
                            GUICtrlSetColor($input_window_handle, 0xFF0000)
                            $invalid_handle = True
                        Else
                            GUICtrlSetColor($input_window_handle, 0x000000)
                            $invalid_handle = False
                        EndIf
                EndSwitch
                If $title_class_data <> "" And $window_handle_data <> "" Then
                    $over_two_fields = True
                    GUICtrlSetColor($label_fields_info, 0xFF0000)
                Else
                    $over_two_fields = False
                    GUICtrlSetColor($label_fields_info, 0x000000)
                EndIf
                UpdateStartButton()
            EndIf
        Case $handle_combo_action
            If $notify_code = $CBN_SELCHANGE Then
                GUICtrlSetState($label_more_infos, $GUI_HIDE)
                GUICtrlSetState($label_x, $GUI_HIDE)
                GUICtrlSetState($input_x, $GUI_HIDE)
                GUICtrlSetState($label_y, $GUI_HIDE)
                GUICtrlSetState($input_y, $GUI_HIDE)
                GUICtrlSetState($label_width, $GUI_HIDE)
                GUICtrlSetState($input_width, $GUI_HIDE)
                GUICtrlSetState($label_height, $GUI_HIDE)
                GUICtrlSetState($input_height, $GUI_HIDE)
                GUICtrlSetState($input_one_line, $GUI_HIDE)
                GUICtrlSetState($label_invisible, $GUI_HIDE)
                GUICtrlSetState($label_visible, $GUI_HIDE)
                GUICtrlSetState($slider_trans, $GUI_HIDE)
                Switch GUICtrlRead($combo_action)
                    Case "Set transparency"
                        UpdateTransparencyLabel()
                        GUICtrlSetState($label_more_infos, $GUI_SHOW)
                        GUICtrlSetState($label_invisible, $GUI_SHOW)
                        GUICtrlSetState($label_visible, $GUI_SHOW)
                        GUICtrlSetState($slider_trans, $GUI_SHOW)
                    Case "Set title"
                        GUICtrlSetData($label_more_infos, "New title:")
                        GUICtrlSetState($label_more_infos, $GUI_SHOW)
                        GUICtrlSetState($input_one_line, $GUI_SHOW)
                    Case "Move"
                        GUICtrlSetData($label_more_infos, "Please enter the new coordinates:")
                        GUICtrlSetState($label_more_infos, $GUI_SHOW)
                        GUICtrlSetState($label_x, $GUI_SHOW)
                        GUICtrlSetState($input_x, $GUI_SHOW)
                        GUICtrlSetState($label_y, $GUI_SHOW)
                        GUICtrlSetState($input_y, $GUI_SHOW)
                    Case "Resize"
                        GUICtrlSetData($label_more_infos, "Please enter the new size:")
                        GUICtrlSetState($label_more_infos, $GUI_SHOW)
                        GUICtrlSetState($label_width, $GUI_SHOW)
                        GUICtrlSetState($input_width, $GUI_SHOW)
                        GUICtrlSetState($label_height, $GUI_SHOW)
                        GUICtrlSetState($input_height, $GUI_SHOW)
                EndSwitch
            EndIf
        Case $handle_checkbox_self_protect
            If $notify_code = $BN_CLICKED Then
                $self_protect = GUICtrlRead($checkbox_self_protect) == 1
            EndIf
        Case $handle_checkbox_set_self_on_top
            If $notify_code = $BN_CLICKED Then
                WinSetOnTop($auWin, "", GUICtrlRead($checkbox_set_self_on_top))
            EndIf
    EndSwitch
EndFunc


Func WM_HSCROLL($hWnd, $Msg, $wParam, $lParam)
    Switch $lParam
        Case $handle_slider_trans
            UpdateTransparencyLabel()
    EndSwitch
EndFunc


While 1

	Switch GUIGetMsg()

		Case $GUI_EVENT_CLOSE
            ; Exit program
			Exit

        Case $button_introduction
            ; Open on GitHub
            ShellExecute("https://github.com/dodaucy/auWin#introduction")

        Case $button_issue
            ; Open a new issue
            ShellExecute("https://github.com/dodaucy/auWin/issues/new")

		Case $button_start
            ; Set window title match mode
            Switch 1
                Case GUICtrlRead($radio_win_title_match_mode_1)
                    AutoItSetOption("WinTitleMatchMode", 1)
                Case GUICtrlRead($radio_win_title_match_mode_2)
                    AutoItSetOption("WinTitleMatchMode", 2)
                Case GUICtrlRead($radio_win_title_match_mode_3)
                    AutoItSetOption("WinTitleMatchMode", 3)
                Case GUICtrlRead($radio_win_title_match_mode_4)
                    AutoItSetOption("WinTitleMatchMode", 4)
            EndSwitch

            ; Clear GUI
			GUICtrlSetData($edit_display, "")
			GUICtrlSetData($progress, 0)

            ; Read input fields
            $action = GUICtrlRead($combo_action)
			$title_class = GUICtrlRead($input_title_class)
			$window_handle = GUICtrlRead($input_window_handle)

            ; Get window list
			If $title_class == "" And $window_handle == "" Then
                ; Get all windows
                $win_list = WinList()
			ElseIf $title_class <> "" Then
                ; Get windows with title / class
                $win_list = WinList($title_class)
			ElseIf $window_handle <> "" Then
                ; Get window with window handle
                $handle_ptr = Ptr($window_handle)
				If WinExists($handle_ptr) Then
                    Local $win_list[2][2] = [[1, ""], [WinGetTitle($handle_ptr), $handle_ptr]]
				Else
					Local $win_list[1][2] = [[0, ""]]
				EndIf
			EndIf

            ; Read more infos
            Switch GUICtrlRead($combo_action)
                Case "Set transparency"
                    $new_trans = GUICtrlRead($slider_trans)
                Case "Set title"
                    $new_title = GUICtrlRead($input_one_line)
                Case "Move"
                    $new_x = GUICtrlRead($input_x)
                    $new_y = GUICtrlRead($input_y)
                Case "Resize"
                    $new_width = GUICtrlRead($input_width)
                    $new_height = GUICtrlRead($input_height)
            EndSwitch

            ; Cycle through all found windows
            For $i = 1 To $win_list[0][0] Step 1

                ; Get infos from window
			    $handle = $win_list[$i][1]
                $pid = WinGetProcess($handle)

                ; Ignore itself
			    If Not $self_protect Or $pid <> @AutoItPID Then

                    ; Run command
					Switch $action
                        Case "Display"
                            $output_text = ""
                        Case "Display handle"
                            $output_text = $handle
						Case "Flash"
							WinFlash($handle)
                            $output_text = "Flashed"
						Case "Send close signal"
							$output_text = ProcessReturnValue(WinClose($handle))
						Case "Send kill signal"
                            $output_text = ProcessReturnValue(WinKill($handle))
						Case "Hide"
							$output_text = ProcessReturnValue(WinSetState($handle, "", @SW_HIDE))
						Case "Show"
							$output_text = ProcessReturnValue(WinSetState($handle, "", @SW_SHOW))
						Case "Minimize"
							$output_text = ProcessReturnValue(WinSetState($handle, "", @SW_MINIMIZE))
						Case "Maximize"
							$output_text = ProcessReturnValue(WinSetState($handle, "", @SW_MAXIMIZE))
						Case "Restore"
							$output_text = ProcessReturnValue(WinSetState($handle, "", @SW_RESTORE))
						Case "Disable"
							$output_text = ProcessReturnValue(WinSetState($handle, "", @SW_DISABLE))
						Case "Enable"
							$output_text = ProcessReturnValue(WinSetState($handle, "", @SW_ENABLE))
						Case "Set on top"
							$output_text = ProcessReturnValue(WinSetOnTop($handle, "", 1))
						Case "Set not on top"
							$output_text = ProcessReturnValue(WinSetOnTop($handle, "", 0))
						Case "Set transparency"
							$output_text = ProcessReturnValue(WinSetTrans($handle, "", $new_trans))
						Case "Set title"
							$output_text = ProcessReturnValue(WinSetTitle($handle, "", $new_title))
						Case "Move"
							$output_text = ProcessReturnValue(WinMove($handle, "", $new_x, $new_y))
						Case "Resize"
                            $output_text = ProcessReturnValue(WinMove($handle, "", Default, Default, $new_width, $new_height))
						Case "Display position and size"
							$pos = WinGetPos($handle)
							$output_text = "X: " & $pos[0] & " Y: " & $pos[1] & " Width: " & $pos[2] & " Height: " & $pos[3]
						Case "Display text"
							$output_text = WinGetText($handle)
                            If $output_text <> "" Then
                                $output_text = @CRLF & $output_text
                            EndIf
					EndSwitch

                    ; Append result to output text box
                    If $output_text <> "" Then
                        $output_text = " " & $output_text
                    EndIf
					GUICtrlSetData($edit_display, "[" & $win_list[$i][0] & "] (PID: " & $pid & ")" & $output_text & @CRLF & GUICtrlRead($edit_display))

				EndIf

                ; Update progress bar
				GUICtrlSetData($progress, $i / $win_list[0][0] * 100)

			Next

            ; Set progress bar to 100% in case it wasn't already
			GUICtrlSetData($progress, 100)

	EndSwitch

WEnd
