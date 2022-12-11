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
#AutoIt3Wrapper_Res_ProductVersion=1.1.0
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
#include <WinAPI.au3>


#Region ### Create GUI ###

    $auWin = GUICreate("auWin (1.1.0)", 522, 474)
    WinSetOnTop($auWin, "", 1)

    $group_search_for_windows = GUICtrlCreateGroup("Select windows", 8, 8, 505, 65)

    $input_search = GUICtrlCreateInput("", 24, 32, 193, 21)
    $handle_input_search = GUICtrlGetHandle($input_search)

    $combo_search_by = GUICtrlCreateCombo("Start of the title", 228, 32, 269, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
    GUICtrlSetData(-1, "Any part of the title|Exact title|HWND / Window Handle (Get with 'Display handle')|PID / Process ID (In the brackets at 'Display')|All windows")
    $handle_combo_search_by = GUICtrlGetHandle($combo_search_by)

    $group_action = GUICtrlCreateGroup("Action", 8, 80, 505, 105)

    $combo_action = GUICtrlCreateCombo("Display", 24, 104, 145, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
    GUICtrlSetData(-1, "Display handle|Flash|Send close signal|Send kill signal|Hide|Show|Minimize|Maximize|Restore|Disable|Enable|Set on top|Set not on top|Set transparency|Set title|Move|Resize|Display position and size|Display text")
    $handle_combo_action = GUICtrlGetHandle($combo_action)

    $button_start = GUICtrlCreateButton("Start", 24, 136, 147, 33)

    $label_more_infos = GUICtrlCreateLabel("", 192, 106, 299, 17, $SS_CENTER)
    GUICtrlSetState(-1, $GUI_HIDE)

    $label_x = GUICtrlCreateLabel("X:", 184, 138, 52, 17, $SS_CENTER)
    GUICtrlSetState(-1, $GUI_HIDE)
    $input_x = GUICtrlCreateInput("0", 240, 136, 89, 21)
    GUICtrlSetState(-1, $GUI_HIDE)
    $label_y = GUICtrlCreateLabel("Y:", 352, 138, 53, 17, $SS_CENTER)
    GUICtrlSetState(-1, $GUI_HIDE)
    $input_y = GUICtrlCreateInput("0", 408, 136, 89, 21)
    GUICtrlSetState(-1, $GUI_HIDE)

    $label_width = GUICtrlCreateLabel("Width:", 184, 138, 52, 17, $SS_CENTER)
    GUICtrlSetState(-1, $GUI_HIDE)
    $input_width = GUICtrlCreateInput("0", 240, 136, 89, 21)
    GUICtrlSetState(-1, $GUI_HIDE)
    $label_height = GUICtrlCreateLabel("Height:", 352, 138, 53, 17, $SS_CENTER)
    GUICtrlSetState(-1, $GUI_HIDE)
    $input_height = GUICtrlCreateInput("0", 408, 136, 89, 21)
    GUICtrlSetState(-1, $GUI_HIDE)

    $input_one_line = GUICtrlCreateInput("", 184, 136, 313, 21)
    GUICtrlSetState(-1, $GUI_HIDE)

    $label_invisible = GUICtrlCreateLabel("Invisible", 184, 138, 50, 17, $SS_CENTER)
    GUICtrlSetState(-1, $GUI_HIDE)
    $label_visible = GUICtrlCreateLabel("Visible", 448, 138, 50, 17, $SS_CENTER)
    GUICtrlSetState(-1, $GUI_HIDE)
    $slider_trans = GUICtrlCreateSlider(240, 136, 206, 37)
    GUICtrlSetLimit(-1, 255, 0)
    GUICtrlSetData(-1, 255)
    GUICtrlSetState(-1, $GUI_HIDE)
    $handle_slider_trans = GUICtrlGetHandle($slider_trans)

    $progress = GUICtrlCreateProgress(8, 192, 505, 33)

    $edit_display = GUICtrlCreateEdit("", 8, 232, 505, 169, BitOR($GUI_SS_DEFAULT_EDIT, $ES_READONLY))

    $checkbox_self_protect = GUICtrlCreateCheckbox("Exclude own process (PID " & @AutoItPID & ")", 13, 408, 239, 25)
    GUICtrlSetState(-1, $GUI_CHECKED)
    $handle_checkbox_self_protect = GUICtrlGetHandle($checkbox_self_protect)
    $checkbox_set_self_on_top = GUICtrlCreateCheckbox("Set self on top", 269, 408, 239, 25)
    GUICtrlSetState(-1, $GUI_CHECKED)
    $handle_checkbox_set_self_on_top = GUICtrlGetHandle($checkbox_set_self_on_top)

    $button_introduction = GUICtrlCreateButton("Help / Introduction", 8, 440, 249, 25)
    $button_issue = GUICtrlCreateButton("Give feedback / Report bugs / Ask a question", 264, 440, 249, 25)

    GUIRegisterMsg($WM_COMMAND, "WM_COMMAND")
    GUIRegisterMsg($WM_HSCROLL, "WM_HSCROLL")
    GUISetState(@SW_SHOW)

#EndRegion


Global $self_protect = True


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


Func SearchCheck()
    $combo_data = GUICtrlRead($combo_search_by)
    If $combo_data = "HWND / Window Handle (Get with 'Display handle')" Then
        $search_data = GUICtrlRead($input_search)
        If $search_data <> "" And Not Ptr($search_data) Then
            GUICtrlSetColor($input_search, 0xFF0000)
            GUICtrlSetState($button_start, $GUI_DISABLE)
        Else
            GUICtrlSetColor($input_search, 0x000000)
            GUICtrlSetState($button_start, $GUI_ENABLE)
        EndIf
        GUICtrlSetState($input_search, $GUI_ENABLE)
    ElseIf $combo_data = "PID / Process ID (In the brackets at 'Display')" Then
        $search_data = GUICtrlRead($input_search)
        If $search_data <> "" And Not StringIsInt($search_data) Then
            GUICtrlSetColor($input_search, 0xFF0000)
            GUICtrlSetState($button_start, $GUI_DISABLE)
        Else
            GUICtrlSetColor($input_search, 0x000000)
            GUICtrlSetState($button_start, $GUI_ENABLE)
        EndIf
        GUICtrlSetState($input_search, $GUI_ENABLE)
    ElseIf $combo_data = "All windows" Then
        GUICtrlSetColor($input_search, 0x000000)
        GUICtrlSetState($button_start, $GUI_ENABLE)
        GUICtrlSetState($input_search, $GUI_DISABLE)
    Else
        GUICtrlSetColor($input_search, 0x000000)
        GUICtrlSetState($button_start, $GUI_ENABLE)
        GUICtrlSetState($input_search, $GUI_ENABLE)
    EndIf
EndFunc


Func UpdateTransparencyLabel()
    GUICtrlSetData($label_more_infos, "Transparency: (" & GUICtrlRead($slider_trans) & ")")
EndFunc


Func WM_COMMAND($hWnd, $Msg, $wParam, $lParam)
    $notify_code = _WinAPI_HiWord($wParam)
    $ctrl_id = _WinAPI_LoWord($wParam)
    Switch $lParam
        Case $handle_input_search
            If $notify_code = $EN_CHANGE Then
                SearchCheck()
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
        Case $handle_combo_search_by
            SearchCheck()
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
            ShellExecute("https://github.com/dodaucy/auWin/issues/new/choose")

		Case $button_start
            ; Disable elements
            GUICtrlSetState($input_search, $GUI_DISABLE)
            GUICtrlSetState($combo_search_by, $GUI_DISABLE)
            GUICtrlSetState($combo_action, $GUI_DISABLE)
            GUICtrlSetState($button_start, $GUI_DISABLE)
            GUICtrlSetState($input_x, $GUI_DISABLE)
            GUICtrlSetState($input_y, $GUI_DISABLE)
            GUICtrlSetState($input_width, $GUI_DISABLE)
            GUICtrlSetState($input_height, $GUI_DISABLE)
            GUICtrlSetState($input_one_line, $GUI_DISABLE)
            GUICtrlSetState($slider_trans, $GUI_DISABLE)
            GUICtrlSetState($checkbox_self_protect, $GUI_DISABLE)
            GUICtrlSetState($checkbox_set_self_on_top, $GUI_DISABLE)
            GUICtrlSetState($button_introduction, $GUI_DISABLE)
            GUICtrlSetState($button_issue, $GUI_DISABLE)

            ; Clear GUI
			GUICtrlSetData($edit_display, "")
			GUICtrlSetData($progress, 0)

            ; Set search mode
            $HWND_search_mode = False
            $PID_search_mode = False
            $all_search_mode = False
            Switch GUICtrlRead($combo_search_by)
                Case "Start of the title"
                    AutoItSetOption("WinTitleMatchMode", 1)
                Case "Any part of the title"
                    AutoItSetOption("WinTitleMatchMode", 2)
                Case "Exact title"
                    AutoItSetOption("WinTitleMatchMode", 3)
                Case "HWND / Window Handle (Get with 'Display handle')"
                    $HWND_search_mode = True
                Case "PID / Process ID (In the brackets at 'Display')"
                    $PID_search_mode = True
                Case "All windows"
                    $all_search_mode = True
            EndSwitch

            ; Read input fields
            $search = GUICtrlRead($input_search)
            $action = GUICtrlRead($combo_action)

            ; Get window list
			If $all_search_mode Or $PID_search_mode Then
                ; Get all windows
                $win_list = WinList()
            ElseIf $HWND_search_mode Then
                ; Get window by window handle
                $handle_ptr = Ptr($search)
                If WinExists($handle_ptr) Then
                    Local $win_list[2][2] = [[1, ""], [WinGetTitle($handle_ptr), $handle_ptr]]
				Else
					Local $win_list[1][2] = [[0, ""]]
				EndIf
            Else
                ; Get window by title
                $win_list = WinList($search)
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

                ; Filter windows
			    If (Not $self_protect Or $pid <> @AutoItPID) And ($all_search_mode Or Not $PID_search_mode Or $pid == $search) Then

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

            ; Enable elements
            If Not $all_search_mode Then
                GUICtrlSetState($input_search, $GUI_ENABLE)
            EndIf
            GUICtrlSetState($combo_search_by, $GUI_ENABLE)
            GUICtrlSetState($combo_action, $GUI_ENABLE)
            GUICtrlSetState($button_start, $GUI_ENABLE)
            GUICtrlSetState($input_x, $GUI_ENABLE)
            GUICtrlSetState($input_y, $GUI_ENABLE)
            GUICtrlSetState($input_width, $GUI_ENABLE)
            GUICtrlSetState($input_height, $GUI_ENABLE)
            GUICtrlSetState($input_one_line, $GUI_ENABLE)
            GUICtrlSetState($slider_trans, $GUI_ENABLE)
            GUICtrlSetState($checkbox_self_protect, $GUI_ENABLE)
            GUICtrlSetState($checkbox_set_self_on_top, $GUI_ENABLE)
            GUICtrlSetState($button_introduction, $GUI_ENABLE)
            GUICtrlSetState($button_issue, $GUI_ENABLE)

	EndSwitch

WEnd
