# auWin

auWin is a program with which you can easily change attributes of windows and do other things with windows. An introduction is [here](#introduction "Introduction").

## Usecases

- Does you find it annoying that an important window moves into the background when you're working? Just [enable always on top](#enable-always-on-top "Enable always on top")!

- Does this window also block the view of the window behind it? Just [set the transparency](#set-transparency "Set transparency")!

- Don't want to see the title bar? Just [move it](#move "Move") to Y -32!

- You want to uncover a hidden window? Just [show it](#show "Show")!

- You don't want to see a program anymore but still want to keep it running? Just [hide it](#hide "Hide")!

- You want to use a disabled window? Just [enable it](#enable "Enable")!

## Preview

![basic](img/preview/basic.png)

![in action](img/preview/in_action.png)

## Run

Download the standalone executable (`auWin.exe`) from [the last release](https://github.com/dodaucy/auWin/releases/latest "Last release") or run `auWin.au3` with [AutoIt 3](https://www.autoitscript.com/files/autoit3/autoit-v3-setup.zip "Download from autoitscript.com").

## Compile yourself

### Requirements

- [AutoIt 3](https://www.autoitscript.com/files/autoit3/autoit-v3-setup.zip "Download from autoitscript.com")

- [SciTE4](https://www.autoitscript.com/autoit3/scite/download/SciTE4AutoIt3.exe "Download from autoitscript.com")

### Compile

1. Right click `auWin.au3` and click on `Compile with Options`. The specified settings for the AutoIt3Wrapper are not loaded using the other options.

![compile_with_options](img/compile/compile_with_options.png)

2. Now just click on `Compile Script`.

![compile_script](img/compile/compile_script.png)

3. There is now an executable in the same folder as the `auWin.au3` file.

![compiled](img/compile/compiled.png)

### Note

⚠️ The executable could be detected as malware. More information [here](https://www.autoitscript.com/forum/topic/34658-are-my-autoit-exes-really-infected/ "Forum post from autoitscript.com").

## Supported operating systems

- Windows XP and Windows Server 2003

- Windows Vista and Windows Server 2008/2008 R2

- Windows 7 / 8 / 10 / 11

Stand november 2022 - From the [AutoIt Downloads Overview](https://www.autoitscript.com/site/autoit/downloads/ "Downloads from autoitscript.com")

## Introduction

### Select windows

![description](img/introduction/select_windows/description.png)

Select a *select mode* and enter something in the *select input*. So you select windows that should be affected by an action.

⚠️ This also selects system windows. So be careful what you do with those windows!

#### Start of the title

In this mode, a window with the [window title](#window-title "Window Title") `Untitled - Notepad` will be selected by `Untitled - Notepad`, `Untitled`, `Un`, etc.

#### Any part of the title

In this mode, a window with the [window title](#window-title "Window Title") `titled Untitled - Notepad` will be selected by `Untitled - Notepad`, `Untitled`, `Notepad`, `pad`, etc.

#### Exact title

In this mode, a window with the [window title](#window-title "Window Title") `Untitled - Notepad` will only be selected by `Untitled - Notepad`.

#### HWND / Window Handle

In this mode, only a specific window with a specific [HWND](#hwnd "HWND") will be selected.

#### PID / Process ID

In this mode, all windows from a specific process with a specific [PID](#pid "PID") will be selected.

#### Any part of the text

In this mode, all windows containing the [text](#text "Text") will be selected.

#### All windows

In this mode, all windows will be selectet. You can't enter anything in the *select input*.

#### Advanced

When have selected the [Start of the title](#start-of-the-title "Start of the title"), [Any part of the title](#any-part-of-the-title "Any part of the title") or [Exact title](#exact-title "Exact title") mode, you can use these properties instead of a [title](#window-title "Window Title") to select windows:

- `TITLE` - [Window title](#window-title "Window Title")
- `CLASS` - The internal window classname
- `REGEXPTITLE` - [Window title](#window-title "Window Title") using a regular expression
- `REGEXPCLASS` - Window classname using a regular expression
- `X` \ `Y` \ `W` \ `H` - The position and size of a window
- `INSTANCE` -  The 1-based instance when all given properties match

One or more properties can be used in the *select input* in the format: `[PROPERTY1 : Value1; PROPERTY2:Value2]`. If a value must contain a `;` it must be doubled.

Here are some examples:

- `[CLASS:Notepad]` - All windows with the classname `Notepad`
- `[TITLE:My Window; CLASS:My Class; INSTANCE:2]` - The 2nd instance of a window with [title](#window-title "Window Title") `My Window` and classname `My Class`
- `[REGEXPTITLE:(?i)(.*SciTE.*|.*Internet Explorer.*)]` - All windows matching [title](#window-title "Window Title") defined by a regular expression

### Actions

![description](img/introduction/actions/description.png)

Select a *action* and then press the *start button*.

#### List selected windows

Just lists all windows found. This can be used to test whether the windows are found or to get the [PID](#pid "PID").

![list selected windows](img/introduction/actions/list_selected_windows.png)

#### Enable always on top

Ensures that all selected windows always stay on top of other programs. Can be undone with [disable always on top](#disable-always-on-top "Disable always on top").

#### Disable always on top

Ensures that other windows can again be above the selected windows. Can be undone with [enable always on top](#enable-always-on-top "Enable always on top").

#### Hide

Hides the selected windows. These continue to run in the background but are no longer visible. Can be undone with [show](#show "Show").

#### Show

Shows the selected windows that were not previously visible. Can be undone with [hide](#hide "Hide").

#### Disable

Disables the selected windows. This means that you can no longer interact with the windows. Can be undone with [enable](#enable "Enable").

#### Enable

Enables the selected windows. After that you can interact with the windows again. Can be undone with [disable](#disable "Disable").

#### Set transparency

Sets the transparency of all selected windows.

![transparency 1](img/introduction/actions/transparency_1.png)

![transparency 2](img/introduction/actions/transparency_2.png)

#### Set title

Sets the [window title](#window-title "Window Title") of the selected windows.

![set title 1](img/introduction/actions/set_title_1.png)

![set title 2](img/introduction/actions/set_title_2.png)

#### Move

Moves all windows to the given position. Windows can also be moved to a negative position.

![move 1](img/introduction/actions/move_1.png)

![move 2](img/introduction/actions/move_2.png)

#### Resize

Changes the size of all selected windows.

![move 1](img/introduction/actions/resize_1.png)

![move 2](img/introduction/actions/resize_2.png)

#### Minimize

Minimizes the selected windows.

#### Maximize

Maximizes the selected windows.

#### Restore

Restores the selected windows. This is the third state next to [minimize](#minimize "Minimize") and [maximize](#maximize "Maximize"). The windows are visible but do not cover the entire screen.

#### Send close signal

Sends a close signal to the selected windows. Some windows may ask for confirmation.

⚠️ Whether this signal is processed is entirely up to the program. The program could still continue. Use your task manager to kill a process.

![close](img/introduction/actions/close.png)

#### Send kill signal

Sends a kill signal to the selected windows.

⚠️ Whether this signal is processed is entirely up to the program. The program could still continue. Use your task manager to kill a process.

#### Flash

Flashes the selected windows until this window is selected.

![flash](img/introduction/actions/flash.png)

#### Display HWND

Displays the [HWND](#hwnd "HWND") of the selected windows in the [output display](#output-display "Output display").

![display HWND](img/introduction/actions/display_HWND.png)

#### Display position and size

Displays the position and size of all selected windows in the [output display](#output-display "Output display").

![display position and size](img/introduction/actions/display_position_and_size.png)

#### Display text

Displays the [text](#text "Text") of all selected windows in the [output display](#output-display "Output display").

![display text](img/introduction/actions/display_text.png)

### Loading bar

This loading bar shows how far the progress of the current action is.

![description](img/introduction/loading_bar/description.png)

### Output display

While auWin is running, the output display shows the return value of the action for each window. The format for each window is this:

`[` [Window Title](#window-title "Window Title") `] (PID:` [PID](#pid "PID") `)` Optional return value

The return value can be requested information such as the position and size of the window or whether the action was successful.

![example 1](img/introduction/the_display/example_1.png)

![example 2](img/introduction/the_display/example_2.png)

### Exclude own process

When activated, no actions are performed on itself.

![exclude own process](img/introduction/exclude_own_process/description.png)

### Stay on top

If activated, auWin always stay on top of other programs.

![stay on top](img/introduction/stay_on_top/description.png)

### Window Title

The title of a window.

![window title](img/introduction/window_title.png)

### Text

The text of a window. Only some windows return a text. You can get the text with the [Display text](#display-text "Display text") action and use it for the [Any part of the text](#any-part-of-the-text "Any part of the text") select mode.

![text](img/introduction/text.png)

### HWND

HWND means window handle. Each window has its own HWND. You can get the HWND with the [Display HWND](#display-hwnd "Display HWND") action and use it for the [HWND / Window Handle](#hwnd--window-handle "HWND / Window Handle") select mode. This select mode can be useful when the window name changes. An example of a HWND is `0x00000000000802EC`.

### PID

PID means process ID or process identifier. Each process has its own PID and can have several windows. You can get the PID with the [List selected windows](#list-selected-windows "List selected windows") action (the PID is in behind `PID:`) or with the task manager and use it for the [PID / Process ID](#pid--process-id "PID / Process ID") select mode. An example of an PID is `980`.

## License

MIT

Copyright (C) 2022 - 2023 dodaucy
