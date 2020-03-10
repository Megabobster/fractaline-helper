; Default AHK stuff. I don't know what this does.

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Start of Config
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Start/stop hotkeys:
; HotkeyStart will start this script. Make sure you have the game running and you're at the Tower Obelisk.
; HotkeyDebugReload will reload this script. This is mostly for debugging.
; HotkeyAbort will exit and kill this script. You might need to mash it a few times.
; HotkeyClickerStart starts a simple autoclicker. The delay between clicks is adjusted by ClickerDelay.
; HotkeyFractalineDump will start simply donating polarized fractaline at the Tower Obelisk with no return.
; TODO: HotkeyDebugReload and HotkeyAbort are the easiest/only ways to stop the simple autoclickers right now.
HotkeyStart = Numpad0
HotkeyDebugReload = Numpad2
HotkeyAbort = Numpad3
HotkeyClickerStart = Numpad4
HotkeyFractalineDump = Numpad1

; Game window size override:
; I haven't tested it, but this script should work on resolutions other than 1920x1080.
; However, it might not work on aspect ratios other than 16:9.
WindowWidth = 1920
WindowHeight = 1080

; Chosen weapon options:
; ChosenWeaponPage (0-2) chooses the page. A value of 1 is the middle page, 2, is the rightmost page.
; Let me know if the Tower Obelisk can have more than 3 pages.
; ChosenWeaponRow (0-2) chooses the row. 0 is the first row, 1 is the second, etc.
; ChosenWeaponColumn (0-4) chooses the column. 0 is the first, 1 is the second, I think you get the idea by now.
; These example values are for the Steelfeather Repeater:
;ChosenWeaponPage = 1
;ChosenWeaponRow = 1
;ChosenWeaponColumn = 2
ChosenWeaponPage = 1
ChosenWeaponRow = 1
ChosenWeaponColumn = 2

; How long should the script run at a time?
; LoopLimit is how many times it will loop before stopping.
; PerLoop is how many weapons it try to make per loop. Normally 4, but up to 7 sometimes.
; The postmaster can hold 21 items, so 4 weapons 5 times will just about fill it up.
; ClickerLimit is a limit to how many times the simple autoclicker or fractaline dumper will loop before stopping.
LoopLimit = 5
PerLoop = 4
ClickerLimit = 100

; Delay:
; How long should the script wait for each action (in ms)?
; With a faster or slower connection/computer/lobby/etc. these values could be made smaller or might need to be larger.
; From limited testing, these values are an adequate compromise of speed for the sake of safety.
LagDelay = 1500
PurchaseDelay = 2000
DonationDelay = 3500
ClickerDelay = 1000

; Additional options coming soon?
; Choose random weapon(s).
; Attempt Perfect Paradox overflow.
; Get and dismantle weapons forever.

; These are measurements of the boundaries of each button at 1920x1080.
; Do not edit these unless you know what you're doing.
BaseWindowWidth = 1920
BaseWindowHeight = 1080
BaseObeliskButton1X1 = 1132
BaseObeliskButton1X2 = 1227
BaseObeliskButton1Y1 = 203
BaseObeliskButton1Y2 = 298
BaseObeliskButton2X = 1233
BaseObeliskButton3Y = 384
BaseFirstBountyX1 = 1345
BaseFirstBountyX2 = 1440
BaseFirstBountyY1 = 210
BaseFirstBountyY2 = 306

; Title of the game window:
; It will grab any window with this text in the title.
; Ensure windows such as its Steam properties aren't open.
WindowTitle = Destiny 2

; Error text:
ErrorGameNotFocused = Unable to focus the game.
ErrorGameNotRunning = Unable to locate the game. Ensure WindowTitle is configured correctly.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; End of Config
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

XModifier := WindowWidth / BaseWindowWidth
YModifier := WindowHeight / BaseWindowHeight
ObeliskOffsetX := (BaseObeliskButton2X - BaseObeliskButton1X1)
ObeliskOffsetY := (BaseObeliskButton3Y - BaseObeliskButton1Y1)
DonationButtonX := ((BaseObeliskButton1X2 + BaseObeliskButton1X1) / 2) * XModifier
DonationButtonY := ((BaseObeliskButton1Y2 + BaseObeliskButton1Y1) / 2) * YModifier
FirstBountyX := ((BaseFirstBountyX2 + BaseFirstBountyX1) / 2) * XModifier
FirstBountyY := ((BaseFirstBountyY2 + BaseFirstBountyY1) / 2) * YModifier
ChosenWeaponX := (((BaseObeliskButton1X2 + BaseObeliskButton1X1) / 2) + (ChosenWeaponColumn * ObeliskOffsetX)) * XModifier
ChosenWeaponY := (((BaseObeliskButton1Y2 + BaseObeliskButton1Y1) / 2) + (ChosenWeaponRow * ObeliskOffsetY)) * YModifier

Hotkey, %HotkeyStart%, Main
Hotkey, %HotkeyDebugReload%, DebugReload
Hotkey, %HotkeyAbort%, Abort
Hotkey, %HotkeyClickerStart%, ClickerStart
Hotkey, %HotkeyFractalineDump%, FractalineDump

return

Main:
If (WinExist(WindowTitle)) {
	Loop %LoopLimit% {
		If (WinExist(WindowTitle)) {
			If (not WinActive(WindowTitle)) {
				MsgBox, %ErrorGameNotFocused%
				break
			}
			Loop %ChosenWeaponPage%{
				Sleep, %LagDelay%
				SendEvent {Right}
			}
			Loop %PerLoop% {
				SendEvent {Click %ChosenWeaponX%, %ChosenWeaponY%, up}
				Sleep, %LagDelay%
				SendEvent {Click down}
				Sleep, %PurchaseDelay%
				SendEvent {Click up}
			}
			Loop %ChosenWeaponPage%{
				Sleep, %LagDelay%
				SendEvent {Left}
			}
			Loop 4 {
				Sleep, %LagDelay%
				SendEvent {Click %DonationButtonX%, %DonationButtonY%, down}
				Sleep, %DonationDelay%
				SendEvent {Click up}
			}
			SendEvent {Tab}
			Sleep, %LagDelay%
			SendEvent {A}
			Loop %PerLoop% {
				Sleep, %LagDelay%
				SendEvent {Click %FirstBountyX%, %FirstBountyY%}
			}
			SendEvent {Escape}
			Sleep, %LagDelay%
		}
	}
	SendEvent {Escape}
}
Else {
	MsgBox, %ErrorGameNotRunning%
}

DebugReload:
SendEvent {Click up}
Reload
return

Abort:
SendEvent {Click up}
ExitApp
return

ClickerStart:
Loop %ClickerLimit% {
	SendEvent {Click}
	Sleep, %ClickerDelay%
}
return

FractalineDump:
Loop %ClickerLimit% {
	Sleep, %LagDelay%
	SendEvent {Click %DonationButtonX%, %DonationButtonY%, down}
	Sleep, %DonationDelay%
	SendEvent {Click up}
}
return
