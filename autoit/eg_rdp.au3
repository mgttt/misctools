#include <GUIConstants.au3>

$oRDP = ObjCreate("MsTscAx.MsTscAx")

GUICreate("Embedded RDP control Test", 1281, 1025, -1 , -1, $WS_OVERLAPPEDWINDOW + $WS_VISIBLE + $WS_CLIPSIBLINGS)

$GUIActiveX = GUICtrlCreateObj($oRDP, 1, 1, 1280, 1024)

GUICtrlSetStyle ($GUIActiveX,  $WS_VISIBLE )
GUICtrlSetResizing ($GUIActiveX,$GUI_DOCKAUTO)

GUISetState()

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

;Hier noch mal alle Parameter bis RDP Version 7
;Das "AdvancedSettings2" <- die Zahl am Ende Symbolisiert ab welcher RDP Version dieser Parameter verfügbar ist

;CipherStrength                                     Read-only               The maximum encryption strength of the current control.
;Connected                                          Read-only               The connection state of the current control.
;ConnectingText                                     Read/write              The text that appears centered in the control while the control is connecting.
;DesktopHeight                                      Read/write              The current control's height, in pixels, on the initial remote desktop.
;DesktopWidth                                       Read/write              The current control's width, in pixels, on the initial remote desktop.
;DisconnectedText                                   Read/write              The text that appears centered in the control before a connection is terminated.
;Domain                                             Read/write              The domain to which the current user logs on.
;FullScreenTitle                                    Write-only              The window title displayed when the control is in full-screen mode.
;HorizontalScrollBarVisible                         Read-only               Indicates whether the control has displayed a horizontal scroll bar.
;SecuredSettings                                    Read-only               A IMsTscSecuredSettings interface pointer.
;SecuredSettingsEnabled                             Read-only               Indicates whether the IMsTscSecuredSettings interface is available.
;Server                                             Read/write              The name of the server to which the current control is connected.
;StartConnected                                     Read/write              Indicates whether the control will establish the RD Session Host server connection immediately upon startup.
;UserName                                           Read/write              The user name logon credential.
;Version                                            Read-only               The version number of the current control.
;VerticalScrollBarVisible                           Read-only               Indicates whether the control displays a vertical scroll bar.
;AdvancedSettings2.AcceleratorPassthrough           Read/write              Specifies if keyboard accelerators should be passed to the server.
;AdvancedSettings2.BitmapCacheSize                  Read/write              The size, in kilobytes, of the bitmap cache file used for 8-bits-per-pixel bitmaps. Valid numeric values of this property are 1 to 32 inclusive.
;AdvancedSettings2.BitmapPersistence                Read/write              Specifies if persistent bitmap caching should be used. Persistent caching can improve performance but requires additional disk space.
;AdvancedSettings2.BitmapVirtualCache16BppSize      Read/write              Specifies the size, in megabytes, of the persistent bitmap cache file to use for the 15 and 16 bits-per-pixel high-color settings.
;AdvancedSettings2.BitmapVirtualCache24BppSize      Read/write              Specifies the size, in megabytes, of the persistent bitmap cache file to use for the 24 bits-per-pixel high-color setting.
;AdvancedSettings2.BitmapVirtualCacheSize           Read/write              Specifies the size, in megabytes, of the persistent bitmap cache file to use for 8-bits-per-pixel color. Valid numeric values of this property are 1 to 32 inclusive. Note that the maximum size for all virtual cache files is 128 MB. Related properties include the BitmapVirtualCache16BppSize and BitmapVirtualCache24BppSize properties.
;AdvancedSettings2.brushSupportLevel                Read/write              This property is not supported.
;AdvancedSettings2.CachePersistenceActive           Read/write              Specifies whether persistent bitmap caching should be used.
;AdvancedSettings2.ClearTextPassword                Write-only              Specifies the password with which to connect. For more information, see the IMsTscNonScriptable interface.
;AdvancedSettings2.ConnectToServerConsole           Read/write              Windows Server 2003, Windows XP with SP2, Windows XP with SP1, and Windows XP: Specifies if the control should attempt to connect to the console session of a server.
;AdvancedSettings2.ConnectWithEndpoint              Write-only              This property is not supported.
;AdvancedSettings2.DedicatedTerminal                Read/write              Windows XP with SP1 and Windows XP:  Specifies if the client should run in dedicated-terminal mode.
;AdvancedSettings2.DisableCtrlAltDel                Read/write              Specifies if the initial explanatory screen in Winlogon should display.
;AdvancedSettings2.DisplayConnectionBar             Read/write              Specifies whether to use the connection bar. The default value is VARIANT_TRUE, which enables the property.
;AdvancedSettings2.DoubleClickDetect                Read/write              Specifies if the client identifies double-clicks for the server.
;AdvancedSettings2.EnableMouse                      Read/write              Windows XP with SP1 and Windows XP:  Specifies if the client sends mouse-button messages to the server.
;AdvancedSettings2.EnableWindowsKey                 Read/write              Specifies if the Windows key can be used in the remote session.
;AdvancedSettings2.EncryptionEnabled                Read/write              This property is not supported. Encryption cannot be disabled.
;AdvancedSettings2.GrabFocusOnConnect               Read/write              Specifies if the client control should have the focus while connecting.
;AdvancedSettings2.HotKeyAltEsc                     Read/write              Specifies the virtual-key code to add to ALT to determine the hotkey replacement for ALT+ESC. VK_INSERT is the default value, with ALT+INSERT as the resulting sequence. This property is valid only when the KeyboardHookMode property is not enabled.
;AdvancedSettings2.HotKeyAltShiftTab                Read/write              Specifies the virtual-key code to add to ALT to determine the hotkey replacement for ALT+SHIFT+TAB. VK_NEXT is the default value, with ALT+PAGE DOWN as the resulting sequence. This property is valid only when the KeyboardHookMode property is not enabled.
;AdvancedSettings2.HotKeyAltSpace                   Read/write              Specifies the virtual-key code to add to ALT to determine the hotkey replacement for ALT+SPACE. VK_DELETE is the default, with ALT+DELETE as the resulting sequence. This property is valid only when the KeyboardHookMode property is not enabled.
;AdvancedSettings2.HotKeyAltTab                     Read/write              Specifies the virtual-key code to add to ALT to determine the hotkey replacement for ALT+TAB. VK_PRIOR is the default value, with ALT+PAGE UP as the resulting sequence. This property is valid only when the KeyboardHookMode property is not enabled.
;AdvancedSettings2.HotKeyCtrlAltDel                 Read/write              Specifies the virtual-key code to add to CTRL+ALT to determine the hotkey replacement for CTRL+ALT+DELETE, also called the secure attention sequence (SAS). VK_END is the default. Note that even when the KeyboardHookMode property is enabled, CTRL+ALT+DELETE is never redirected to the remote server; CTRL+ALT+DELETE is the local SAS sequence.
;AdvancedSettings2.HotKeyCtrlEsc                    Read/write              Specifies the virtual-key code to add to ALT to determine the hotkey replacement for CTRL+ESC. VK_HOME is the default value, with ALT+HOME as the resulting sequence. This property is valid only when the KeyboardHookMode property is not enabled.
;AdvancedSettings2.HotKeyFullScreen                 Read/write              Specifies the virtual-key code to add to CTRL+ALT to determine the hotkey replacement for switching to full-screen mode. VK_CANCEL is the default value.
;AdvancedSettings2.InputEventsAtOnce                Read/write              This property is not supported. Windows XP with SP1 and Windows XP:  Specifies the typical number of input events to batch together.
;AdvancedSettings2.keepAliveInterval                Read/write              Specifies an interval, in milliseconds, at which the client sends keep-alive messages to the server. The default value of the property is zero, which disables keep-alive messages. The minimum valid value of this property is 10,000, which represents 10 seconds. Note that a group policy setting that specifies whether persistent client connections to the server are allowed can override this property setting.
;AdvancedSettings2.KeyboardFunctionKey              Read/write              Valid for Windows CE only.
;AdvancedSettings2.KeyboardSubType                  Read/write              Valid for Windows CE only.
;AdvancedSettings2.KeyboardType                     Read/write              Valid for Windows CE only.
;AdvancedSettings2.LoadBalanceInfo                  Read/write              Specifies the load balancing cookie that will be placed in the X.224 Connection Request packet in the RD Session Host server protocol connection sequence.
;AdvancedSettings2.maxEventCount                    Read/write              This property is not supported. Windows XP with SP1 and Windows XP:  Specifies the maximum number of input events to batch together.
;AdvancedSettings2.MaximizeShell                    Read/write              Specifies if programs launched with the StartProgram property should be maximized.
;AdvancedSettings2.minInputSendInterval             Read/write              Specifies the minimum interval, in milliseconds, between the sending of mouse events.
;AdvancedSettings2.MinutesToIdleTimeout             Read/write              Specifies the maximum length of time, in minutes, that the client should remain connected without user input. If the specified time elapses, the control calls the IMsTscAxEvents::OnIdleTimeoutNotification method.
;AdvancedSettings2.NotifyTSPublicKey                Read/write              This property is not supported.
;AdvancedSettings2.NumBitmapCaches                  Read/write              This property is not supported. Windows XP with SP1 and Windows XP:  Specifies the number of bitmap caches to use.
;AdvancedSettings2.orderDrawThreshold               Read/write              This property is not supported. Windows XP with SP1 and Windows XP:  Specifies the maximum number of drawing operations to batch together for rendering.
;AdvancedSettings2.overallConnectionTimeout         Read/write              Specifies the total length of time, in seconds, that the client control waits for a connection to complete. The maximum valid value of this property is 600, which represents 10 minutes. If the specified time elapses before connection completes, the control disconnects and calls the IMsTscAxEvents::OnDisconnected method. A related property is singleConnectionTimeout.
;AdvancedSettings2.PerformanceFlags                 Read/write              Specifies a set of features that can be set at the server to improve performance.
;AdvancedSettings2.PersistCacheDirectory            Write-only              This property is not supported. Windows XP with SP1 and Windows XP:  Specifies the path to the directory for storage of bitmap cache files.
;AdvancedSettings2.PinConnectionBar                 Read/write              Specifies the state of the UI connection bar. Setting this property to VARIANT_TRUE sets the state to "lowered", that is, invisible to the user and unavailable for input. VARIANT_FALSE sets the state to "raised" and available for user input.
;AdvancedSettings2.RdpdrClipCleanTempDirString      Read/write              Windows XP with SP1 and Windows XP:  Specifies the message to be displayed before exiting while the client control is deleting files in a temporary directory; for example, "Cleaning up temporary directory"
;AdvancedSettings2.RdpdrClipPasteInfoString         Read/write              Windows XP with SP1 and Windows XP:  Specifies the message to be displayed while the client control processes clipboard information in preparation for pasting the data; for example, "Preparing to paste information".
;AdvancedSettings2.RdpdrLocalPrintingDocName        Read/write              Windows XP with SP1 and Windows XP:  Specifies the name to be used for printer documents that are redirected; for example, "Remote Desktop Redirected Printer Document".
;AdvancedSettings2.RDPPort                          Read/write              Specifies the connection port. The default value is 3389.
;AdvancedSettings2.RedirectDrives                   Read/write              Specifies if redirection of disk drives is allowed.
;AdvancedSettings2.RedirectPorts                    Read/write              Specifies if redirection of local ports (for example, COM and LPT) is allowed.
;AdvancedSettings2.RedirectPrinters                 Read/write              Specifies if redirection of printers is allowed.
;AdvancedSettings2.RedirectSmartCards               Read/write              Specifies if redirection of smart cards is allowed.
;AdvancedSettings2.SasSequence                      Read/write              Specifies the secure access sequence the client will use to access the login screen on the server.
;AdvancedSettings2.ScaleBitmapCachesByBPP           Read/write              Windows XP with SP1 and Windows XP:  Specifies if the size of bitmap caches should be scaled by bit depth (bits per pixel). The default value, enabled or nonzero, is recommended.
;AdvancedSettings2.ShadowBitmap                     Read/write              Windows Vista, Windows Server 2003, and Windows XP:  Specifies if shadow bitmaps should be used.
;AdvancedSettings2.shutdownTimeout                  Read/write              Specifies the length of time, in seconds, to wait for the server to respond to a disconnection request. The default value of the property is 10. The maximum valid value of the property is 600, which represents 10 minutes. If the server does not reply within the specified time, the client control disconnects.
;AdvancedSettings2.singleConnectionTimeout          Read/write              Specifies the maximum length of time, in seconds, that the client control waits for a connection to an IP address. During connection the control may attempt to connect to multiple IP addresses. The maximum valid value of this property is 600. A related property is overallConnectionTimeout.
;AdvancedSettings2.SmartSizing                      Read/write              Specifies if the display should be scaled to fit the client area of the control. VARIANT_TRUE enables scaling. Note that scroll bars do not appear when the SmartSizing property is enabled.
;AdvancedSettings2.SmoothScroll                     Read/write              Windows XP with SP1 and Windows XP:  Specifies if the Remote Desktop window should scroll smoothly when scroll bars are used. The default is a nonzero value, which enables smooth scrolling and increases the scrolling response on slower computers. The property has no effect on scrolling in the actual remote session.
;AdvancedSettings2.TransportType                    Read/write              Specifies the transport type used by the client. This property is not used by the Remote Desktop ActiveX control.
;AdvancedSettings2.WinCEFixedPalette                Read/write              Valid for Windows CE only.
;AdvancedSettings2.CanAutoReconnect                 Read-only               Specifies whether the client control is able to reconnect automatically to the current session in the event of a network disconnection.
;AdvancedSettings2.EnableAutoReconnect              Read/write              Specifies whether to enable the client control to reconnect automatically to a session in the event of a network disconnection.
;AdvancedSettings2.MaxReconnectAttempts             Read/write              Specifies the number of times to try to reconnect during automatic reconnection. The valid values of this property are 0 to 200 inclusive.
;AdvancedSettings2.allowBackgroundInput             Read/write              Specifies whether background input mode is enabled.
;AdvancedSettings2.BitmapPeristence                 Read/write              Specifies whether bitmap caching is enabled. Note  The spelling error in the name of the property is in the released version of the control.
;AdvancedSettings2.Compress                         Read/write              Specifies whether compression is enabled.
;AdvancedSettings2.ContainerHandledFullScreen       Read/write              Specifies whether the container-handled full-screen mode is enabled.
;AdvancedSettings2.DisableRdpdr                     Read/write              Specifies whether printer and clipboard redirection is enabled.
;AdvancedSettings2.IconFile                         Write-only              Specifies the name of the file containing icon data that will be accessed when displaying the client in full-screen mode.
;AdvancedSettings2.IconIndex                        Write-only              Specifies the index of the icon within the current icon file.
;AdvancedSettings2.KeyBoardLayoutStr                Write-only              Specifies the name of the active input locale identifier (formerly called the keyboard layout) to use for the connection.
;AdvancedSettings2.PluginDlls                       Write-only              Specifies the names of virtual channel client DLLs to be loaded.
;AdvancedSettings4.AuthenticationLevel              Read/write              Specifies the authentication level to use for the connection.
;AdvancedSettings3.ConnectionBarShowMinimizeButton Read/write          Specifies whether to display the Minimize button on the connection bar.
;AdvancedSettings3.ConnectionBarShowRestoreButton   Read/write          Specifies whether to display the Restore button on the connection bar.
;AdvancedSettings5.AudioRedirectionMode             Read/write              The audio redirection mode. The AudioRedirectionMode property has the following possible values.
;                                                                           AUDIO_MODE_REDIRECT 0 (Audio redirection is enabled and the option for redirection is "Bring to this computer". This is the default mode.)
;                                                                           AUDIO_MODE_PLAY_ON_SERVER 1 (Audio redirection is enabled and the option is "Leave at remote computer". The "Leave at remote computer" option is supported only when connecting remotely to a host computer that is running Windows Vista. If the connection is to a host computer that is running Windows Server 2008, the option "Leave at remote computer" is changed to "Do not play". )
;                                                                           AUDIO_MODE_NONE 2 (Audio redirection is enabled and the mode is "Do not play".)
;AdvancedSettings5.BitmapVirtualCache32BppSize      Read/write              Specifies the virtual cache file size for 32 bits per pixel (bpp) bitmaps. The maximum value is 48 megabytes (MB).
;AdvancedSettings5.ConnectionBarShowPinButton       Read/write              Specifies whether the pin button should be shown on the connection bar. By default, the value is TRUE.
;AdvancedSettings5.PublicMode                       Read/write              Specifies whether public mode should be enabled or disabled. By default, public mode is set to FALSE.
;AdvancedSettings5.RedirectClipboard                Read/write              Specifies whether clipboard redirection should be enabled or disabled. By default, clipboard redirection mode is set to TRUE (enabled).
;AdvancedSettings5.RedirectDevices                  Read/write              Specifies whether redirected devices should be enabled or disabled. By default, redirected devices mode is set to FALSE.
;AdvancedSettings5.RedirectPOSDevices               Read/write              Specifies whether Point of Service redirected devices should be enabled or disabled. By default, Point of Service redirected devices mode is set to FALSE.
;AdvancedSettings6.AuthenticationServiceClass       Read/write              Specifies the service principal name (SPN) to use for authentication to the server.
;AdvancedSettings6.AuthenticationType               Read-only               Specifies the type of authentication used for this connection.
;AdvancedSettings6.ConnectToAdministerServer        Read/write              Retrieves or specifies whether the ActiveX control should attempt to connect to the server for administrative purposes.
;AdvancedSettings6.EnableCredSspSupport             Read/write              Specifies whether the Credential Security Service Provider (CredSSP) is enabled for this connection.
;AdvancedSettings6.HotKeyFocusReleaseLeft           Read/write              Specifies the virtual-key code to add to CTRL+ALT to determine the hotkey replacement for CTRL+ALT+LEFT ARROW.
;AdvancedSettings6.HotKeyFocusReleaseRight          Read/write              Specifies the virtual-key code to add to CTRL+ALT to determine the hotkey replacement for CTRL+ALT+RIGHT ARROW.
;AdvancedSettings6.PCB                              Read/write              Specifies the preconnection BLOB (PCB) setting to use prior to connecting for transmission to the server.
;AdvancedSettings6.RelativeMouseMode                Read/write              Specifies whether the mouse should use relative mode.
;AdvancedSettings7.AudioCaptureRedirectionMode      Read/write              Specifies or retrieves a value that indicates whether the default audio input device is redirected from the client to the remote session.
;AdvancedSettings7.AudioQualityMode                 Read/write              Specifies or retrieves a value that indicates the audio quality mode setting for redirected audio.
;AdvancedSettings7.EnableSuperPan                   Read/write              Specifies or retrieves a value that indicates whether SuperPan is enabled or disabled.
;AdvancedSettings7.NetworkConnectionType            Read/write              Specifies or retrieves a value that indicates the network connection type.
;AdvancedSettings7.RedirectDirectX                  Read/write              This property is not used.
;AdvancedSettings7.SuperPanAccelerationFactor       Read/write              Specifies or retrieves a value that indicates the SuperPan acceleration factor.
;AdvancedSettings7.VideoPlaybackMode                Read/write              Specifies or retrieves a value that indicates the video playback mode.
