#Requires AutoHotkey v2.0
#SingleInstance Force

LogEvent("script-start", "ahk_version=" A_AhkVersion)
OnExit(LogScriptExit)

; Use CapsLock as Left Ctrl system-wide. Double-tap it within 300 ms to
; toggle CapsLock.
capsLockDoubleTapMs := 300
capsLockPressedAt := 0
capsLockLastTapAt := 0
capsLockCtrlDown := false

*CapsLock::
{
    global capsLockPressedAt, capsLockCtrlDown
    LogHotkey()

    ; Ignore key-repeat events while CapsLock is already held.
    if capsLockCtrlDown
        return

    capsLockCtrlDown := true
    capsLockPressedAt := A_TickCount
    Send "{Blind}{LCtrl DownR}"

    ; Keep this hotkey thread active until physical release so keyboard
    ; auto-repeat cannot trigger enough CapsLock events to trip flood protection.
    KeyWait("CapsLock")
}

*CapsLock Up::
{
    global capsLockDoubleTapMs, capsLockPressedAt, capsLockLastTapAt
    global capsLockCtrlDown
    LogHotkey()

    if capsLockCtrlDown {
        Send "{Blind}{LCtrl up}"
        capsLockCtrlDown := false
    }

    now := A_TickCount
    pressDuration := now - capsLockPressedAt
    if pressDuration > capsLockDoubleTapMs {
        capsLockLastTapAt := 0
        return
    }

    if capsLockLastTapAt && now - capsLockLastTapAt <= capsLockDoubleTapMs {
        SetCapsLockState GetKeyState("CapsLock", "T") ? "Off" : "On"
        capsLockLastTapAt := 0
    } else {
        capsLockLastTapAt := now
    }
}

; CapsLock+A/E: move to the start/end of the current line while keeping
; physical Ctrl+A and Ctrl+E unchanged.
#HotIf GetKeyState("CapsLock", "P")
*a::
{
    LogHotkey()
    Send "{Home}"
}
*e::
{
    LogHotkey()
    Send "{End}"
}
#HotIf

; Alt+I: activate Chrome, or start it when it is not running.
!i::ActivateOrRun(
    "ahk_exe chrome.exe",
    "C:\Program Files\Google\Chrome\Application\chrome.exe"
)

; Alt+E: activate Neovide, or start it when it is not running.
!e::ActivateOrRun(
    "ahk_exe neovide.exe",
    "C:\Users\TONGYU\scoop\apps\neovide\current\neovide.exe"
)

; Ctrl+Alt+N: activate Notion, or start it when it is not running.
^!n::ActivateOrRun(
    "ahk_exe Notion.exe",
    "C:\Users\TONGYU\scoop\apps\notion\current\Notion.exe"
)

; Ctrl+Alt+I: activate IntelliJ IDEA, or start it when it is not running.
^!i::ActivateOrRun(
    "ahk_exe idea64.exe",
    "C:\Users\TONGYU\scoop\apps\idea\current\IDE\bin\idea64.exe"
)

; Alt+U: activate Codex, or start the installed Windows app.
!u::ActivateOrRun(
    "ahk_exe ChatGPT.exe",
    'explorer.exe "shell:AppsFolder\OpenAI.Codex_2p2nqsd0c76g0!App"'
)

ActivateOrRun(windowSelector, launchCommand) {
    LogHotkey()

    if WinExist(windowSelector) {
        if WinGetMinMax(windowSelector) = -1
            WinRestore(windowSelector)
        WinActivate(windowSelector)
        return
    }

    Run(launchCommand)
    if WinWait(windowSelector, , 10)
        WinActivate(windowSelector)
}

LogHotkey() {
    details := Format(
        'current="{}" prior="{}" elapsed_ms={}',
        A_ThisHotkey,
        A_PriorHotkey,
        A_TimeSincePriorHotkey
    )
    LogEvent("hotkey", details)
}

LogScriptExit(exitReason, exitCode) {
    LogEvent(
        "script-exit",
        Format('reason="{}" code={}', exitReason, exitCode)
    )
}

LogEvent(eventType, details := "") {
    static logDirectory := A_ScriptDir "\logs"
    static logFile := logDirectory "\app-hotkeys.log"
    static backupFile := logFile ".1"
    static maxLogBytes := 512 * 1024

    ; Diagnostics must never stop the hotkey script if logging fails.
    try {
        if !DirExist(logDirectory)
            DirCreate(logDirectory)

        if FileExist(logFile) && FileGetSize(logFile) >= maxLogBytes
            FileMove(logFile, backupFile, 1)

        line := Format(
            "{} tick={} event={} {}`n",
            FormatTime(, "yyyy-MM-dd HH:mm:ss"),
            A_TickCount,
            eventType,
            details
        )
        FileAppend(line, logFile, "UTF-8")
    }
}
