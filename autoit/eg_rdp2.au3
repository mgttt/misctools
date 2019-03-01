#include <GUIConstants.au3>

$oRDP = ObjCreate("MsTscAx.MsTscAx")
$GUI=GUICreate("Embedded RDP control Test", 1281, 1025, -1 , -1, $WS_OVERLAPPEDWINDOW + $WS_VISIBLE + $WS_CLIPSIBLINGS)

$GUIActiveX = GUICtrlCreateObj($oRDP, 1, 1, 1280, 1024)

;GUICtrlSetStyle ($GUIActiveX,  $WS_VISIBLE )

GUISetState()

;START - fixing the styles of the controls and the GUI to prevent clipping
$hUIContainerClass = ControlGetHandle($GUI, "", "UIContainerClass1")
$hUIMainClass = ControlGetHandle($GUI, "", "UIMainClass1")
$hATL = ControlGetHandle($GUI, "", "ATL:46F016981")
;Const $WS_EX_NOPARENTNOTIFY = 0x4
;Const $WS_EX_NOINHERITLAYOUT = 0x100000
$hUIContainerClassStyle = BitOR($WS_CHILD, $WS_CLIPCHILDREN, $WS_CLIPSIBLINGS, $WS_VISIBLE) ; 0x56000000
$hUIContainerClassStyleEx = BitOR($WS_EX_NOINHERITLAYOUT, $WS_EX_NOPARENTNOTIFY) ; 0x00100004
$hUIMainClassStyle = BitOR($WS_CHILD, $WS_CLIPCHILDREN, $WS_CLIPSIBLINGS, $WS_SYSMENU, $WS_VISIBLE) ; 0x56080000
$hUIMainClassStyleEx = 0x0
$hATLStyle = BitOR($WS_CHILD, $WS_CLIPCHILDREN, $WS_CLIPSIBLINGS, $WS_VISIBLE) ; 0x56000000
$hATLStyleEx = 0x0
$guiStyle = BitOR($WS_BORDER, $WS_CAPTION, $WS_CLIPCHILDREN, $WS_CLIPSIBLINGS, $WS_DLGFRAME, $WS_GROUP, $WS_MAXIMIZE, $WS_MAXIMIZEBOX, $WS_MINIMIZEBOX, $WS_SYSMENU, $WS_TABSTOP, $WS_THICKFRAME, $WS_VISIBLE) ; 0x17CF0100
$guiStyleEx = $WS_EX_WINDOWEDGE ; 0x00000100
_SetStyle($hUIContainerClass,$hUIContainerClassStyle,$hUIContainerClassStyleEx)
_SetStyle($hUIMainClass,$hUIMainClassStyle,$hUIMainClassStyleEx)
_SetStyle($hATL,$hATLStyle,$hATLStyleEx)
_SetStyle($gui,$guiStyle,$guiStyleEx)
Func _SetStyle($hwnd,$style,$exstyle)
    DllCall("user32.dll", "long", "SetWindowLong", "hwnd", $hwnd, "int", -16, "long", $style)
    DllCall("user32.dll", "long", "SetWindowLong", "hwnd", $hwnd, "int", -20, "long", $exstyle)
EndFunc
;END - fixing the styles of the controls and the GUI to prevent clipping

;[EDIT] I went ahead and found out what hex values of the styles I originally posted here represented.
; $WS_EX_NOPARENTNOTIFY and $WS_EX_NOINHERITLAYOUT seem to be fairly important
; This may still be important for other projects with similar problems.

$oRDP.Server = "127.0.0.1"
$oRDP.Domain = ""
$oRDP.UserName = "test"
$oRDP.AdvancedSettings2.ClearTextPassword = "test1234"

$oRdp.ConnectingText = "Connecting..."
$oRdp.DisconnectedText = "Disconnected"

$oRDP.FullScreen = False; Vollbild ja/nein - hat nichts mit der Auflösung zu tun
;$oRDP.AdvancedSettings2.RedirectDrives = True ; Sollen die Laufwerke mitgenommen werden
;$oRDP.AdvancedSettings2.RedirectPrinters = False ; Sollen die Drucker mitgenommen werden
;$oRDP.AdvancedSettings2.RedirectPorts = False ; Ports wie LPT1 etc
;$oRDP.AdvancedSettings2.RedirectSmartCards = False ; SmartCards für Authentifizierung
;$oRDP.ConnectingText = "Connecting ...." ; Text der erscheint bevor das Bild des Servers erscheint
;; Nachfolgende Zeilen von eigenen Test's - ich musste mal das mit den "AdvancedSettings2" 3 4 etc. ausklingeln
$oRDP.AdvancedSettings2.EnableAutoReconnect = True
;$oRDP.AdvancedSettings2.allowBackgroundInput = False
$oRDP.AdvancedSettings2.ConnectionBarShowRestoreButton = True
;$oRDP.AdvancedSettings5.AudioRedirectionMode = 0

$oRDP.Connect()

While 1
    $msg = GUIGetMsg()
    Select
        Case $msg = $GUI_EVENT_CLOSE
            ExitLoop
    EndSelect
WEnd

GUIDelete()

Exit

