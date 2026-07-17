#Requires AutoHotkey v2.0
#SingleInstance Force

; Use CapsLock as Left Ctrl system-wide. Double-tap it within 300 ms to
; toggle CapsLock.
capsLockDoubleTapMs := 300
capsLockPressedAt := 0
capsLockLastTapAt := 0
capsLockCtrlDown := false

*CapsLock::
{
    global capsLockPressedAt, capsLockCtrlDown

    ; Ignore key-repeat events while CapsLock is already held.
    if capsLockCtrlDown
        return

    capsLockCtrlDown := true
    capsLockPressedAt := A_TickCount
    Send "{Blind}{LCtrl down}"
}

*CapsLock Up::
{
    global capsLockDoubleTapMs, capsLockPressedAt, capsLockLastTapAt
    global capsLockCtrlDown

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

; Alt+I: activate Chrome, or start it when it is not running.
!i::ActivateOrRun(
    "ahk_exe chrome.exe",
    "C:\Program Files\Google\Chrome\Application\chrome.exe"
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

; Alt+L: activate ChatGPT, or start the installed Windows app.
!l::ActivateOrRun(
    "ahk_exe ChatGPT.exe",
    'explorer.exe "shell:AppsFolder\OpenAI.Codex_2p2nqsd0c76g0!App"'
)

ActivateOrRun(windowSelector, launchCommand) {
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
