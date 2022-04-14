#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

!r::Reload

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; replicate logitech mx master commands
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
CoordMode, Mouse, Screen
MouseMoveStartDistanceX := 300
MouseMoveStartDistanceY := 25
KeyIsPressed := 0
count := 0
F10::
    KeyIsPressed := 1
    MouseGetPos, MouseStartPositionX, MouseStartPositionY
    while ( KeyIsPressed = 1 && count < 100)
    {
        MouseGetPos, MouseCurrentPositionX, MouseCurrentPositionY
        MouseMoveCurrentDistanceX := MouseStartPositionX - MouseCurrentPositionX
        if ( (MouseMoveCurrentDistanceX) < (-1 * MouseMoveStartDistanceX) )
        {
            Send ^{Media_Next}
            MouseStartPositionX := MouseCurrentPositionX
            count += 100
        }
        if ( (MouseMoveCurrentDistanceX) > (MouseMoveStartDistanceX) )
        {
            Send ^{Media_Prev}
            MouseStartPositionX := MouseCurrentPositionX
            count += 100
        }
	MouseMoveCurrentDistanceY := MouseStartPositionY - MouseCurrentPositionY
        YDelta := Sqrt(Abs(MouseMoveCurrentDistanceY / 20))
        if ( (MouseMoveCurrentDistanceY) < (-1 * MouseMoveStartDistanceY) )
        {
            Send ^{Volume_Down %YDelta%}
            MouseStartPositionY := MouseCurrentPositionY
            count++
        }
        if ( (MouseMoveCurrentDistanceY) > (MouseMoveStartDistanceY) )
        {
            Send ^{Volume_Up %YDelta%}
            MouseStartPositionY := MouseCurrentPositionY
            count++
        }
    }
    return

F10 UP::
    KeyIsPressed := 0
    if (count = 0){
        Send ^{Media_Play_Pause}
    }
    count := 0
return



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ctrl + g, serach 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


                    ; ctrl+g : open highlighted text in browser and do google search / visit site (if it's url)


                    ; run script as admin (reload if not as admin) 
                    if not A_IsAdmin
                    {
                    Run *RunAs "%A_ScriptFullPath%"  ; Requires v1.0.92.01+
                    ExitApp
                    }

                    #NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
                    ; #Warn  ; Enable warnings to assist with detecting common errors.
                    SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
                    SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
                    #SingleInstance Force
                    SetTitleMatchMode 2


                    ^g::
                    MyClip := ClipboardAll
                    Clipboard = ; empty the clipboard
                    Send, ^c
                    ClipWait, 2
                    if ErrorLevel  ; ClipWait timed out.
                    {
                        return
                    }
                    if RegExMatch(Clipboard, "^[^ ]*\.[^ ]*$")
                    {
                        Run "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" %Clipboard%
                    }
                    else  
                    {
                        ; Modify some characters that screw up the URL
                        ; RFC 3986 section 2.2 Reserved Characters (January 2005):  !*'();:@&=+$,/?#[]
                        StringReplace, Clipboard, Clipboard, `r`n, %A_Space%, All
                        StringReplace, Clipboard, Clipboard, #, `%23, All
                        StringReplace, Clipboard, Clipboard, &, `%26, All
                        StringReplace, Clipboard, Clipboard, +, `%2b, All
                        StringReplace, Clipboard, Clipboard, ", `%22, All
                        Run % "https://www.google.com/search?hl=en&q=" . clipboard ; uriEncode(clipboard)
                    }
                    Clipboard := MyClip
                    return

                    ; Handy function.
                    ; Copies the selected text to a variable while preserving the clipboard.
                    GetText(ByRef MyText = "")
                    {
                    SavedClip := ClipboardAll
                    Clipboard =
                    Send ^c
                    ClipWait 0.5
                    If ERRORLEVEL
                    {
                        Clipboard := SavedClip
                        MyText =
                        Return
                    }
                    MyText := Clipboard
                    Clipboard := SavedClip
                    Return MyText
                    }

                    ; Pastes text from a variable while preserving the clipboard.
                    PutText(MyText)
                    {
                    SavedClip := ClipboardAll 
                    Clipboard =              ; For better compatability
                    Sleep 20                 ; with Clipboard History
                    Clipboard := MyText
                    Send ^v
                    Sleep 100
                    Clipboard := SavedClip
                    Return
                    }

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ctrl + s, chrome switcheroo
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;KeepRunning:
    ;#IfWinActive, ahk_exe chrome.exe
    ;^s::
        ;send ^+a
        ;return
;RETURN


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; snip her I barely know her
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

^+4::
    if WinExist( "Snipping Tool" )
    {
        ControlClick, x40 y40, Snipping Tool
    }
    else 
    {
        Run SnippingTool.exe /clip
    }
    return



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; caps lock -> ctrl
; for keyboards not supported by via remapping, caps -> ctrl & esc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                    *CapsLock::
                        if (g_ControlRepeatDetected)
                        {
                            return
                        }
                        send,{Ctrl down}
                        g_LastCtrlKeyDownTime := A_TickCount
                        g_AbortSendEsc := false
                        g_ControlRepeatDetected := true
                        return

                    *CapsLock Up::
                        send,{Ctrl up}
                        g_ControlRepeatDetected := false
                        if (g_AbortSendEsc)
                        {
                            return
                        }
                        current_time := A_TickCount
                        time_elapsed := current_time - g_LastCtrlKeyDownTime
                        if (time_elapsed <= 100)
                        {
                            SendInput {Esc}
                        }
                        return

                    ; 
                    ; for keyboards supported by via remapping, caps -> ctrl & esc
                    ;
                    *Ctrl::
                        if (g_ControlRepeatDetected)
                        {
                            return
                        }
                        send,{Ctrl down}
                        g_LastCtrlKeyDownTime := A_TickCount
                        g_AbortSendEsc := false
                        g_ControlRepeatDetected := true
                        return

                    *Ctrl Up::
                        send,{Ctrl up}
                        g_ControlRepeatDetected := false
                        if (g_AbortSendEsc)
                        {
                            return
                        }
                        current_time := A_TickCount
                        time_elapsed := current_time - g_LastCtrlKeyDownTime
                        if (time_elapsed <= 100)
                        {
                            SendInput {Esc}
                        }
                        return


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; switch through apps
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ActivateIfExists(name)
{
  exist := WinExist(name)
  if %exist%
    WinActivate, %name%
}

; Function that either activates the window, if it exists or
; launches the exe given
ActivateOrLaunch(name, exeName, windowType:="max")
{
  WinGet, currProcessPath, ProcessPath, A
  if (currProcessPath = exeName)
    WinMinimize, A
  else
  {
    exist := WinExist(name)
    if %exist%
      WinActivate, %name%
    else
      if (windowType = "-")
        Run %exeName%
      else
        Run, %exeName%,, max
  }
}

ActivateAndCycle(exe)
{
  IfWinExist, ahk_exe %exe%
    IfWinActive, ahk_exe %exe%
      WinActivateBottom, ahk_exe %exe%
    else
      WinActivate, ahk_exe %exe%
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; aforementioned apps
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

                    ^1::
                    if WinExist("ahk_exe chrome.exe")
                        {
                            if WinActive("ahk_exe chrome.exe")
                            {
                                WinGetClass, ActiveClass, A
                                WinSet, Bottom,, A
                                WinActivate, ahk_class %ActiveClass%
                                return
                            }
                            else
                            {	
                                WinActivate
                            }
                        }	
                        else
                            Run Chrome
                        return

                    ^2::
                        path := "C:\Users\d\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"
                        Run, %path%
                        return

                    ^3::
                        ActivateOrLaunch("Notion",  "C:\Users\d\AppData\Local\Programs\Notion\Notion.exe")
                        RETURN

                    ^4::
                    if WinExist("ahk_exe code.exe")
                        {
                            if WinActive("ahk_exe code.exe")
                            {
                                WinGetClass, ActiveClass, A
                                WinSet, Bottom,, A
                                WinActivate, ahk_class %ActiveClass%
                                return
                            }
                            else
                            {	
                                WinActivate
                            }
                        }	
                        else
                            Run C:\Users\d\AppData\Local\Programs\Microsoft VS Code\Code.exe
                        return
                        
                    ; well, one of these works
                    ^5::
                    Run, C:\Program Files (x86)\VPNetwork LLC\TorGuard\TorGuardDesktopQt.exe
                    if WinExist("ahk_exe Firefox.exe")
                        {
                            if WinActive("ahk_exe Firefox.exe")
                            {
                                WinGetClass, ActiveClass, A
                                WinSet, Bottom,, A
                                WinActivate, ahk_class %ActiveClass%
                                return
                            }
                            else
                            {	
                                Run, firefox.exe -private
                            }
                        }	
                        else
                            Run, firefox.exe -private
                        return

                    ^6::
                    WinActivate, spotify.exe
                    WinActivate, Spotify
                    if WinExist("ahk_exe spotify.exe")
                    WinSet, AlwaysOnTop, On, ahk_exe spotify.exe
                    WinSet, AlwaysOnTop, Toggle, ahk_exe spotify.exe
                    ;Run C:\Users\d\AppData\Roaming\Spotify\Spotify.exe
                    ;WinWaitActive, ahk_exe spotify.exe
                    return

                    ^0::
                    Run C:\Users\d\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\startup.ahk
                    return

#s::
 DllCall("PowrProf\SetSuspendState", "int", 0, "int", 0, "int", 0)
 return