Global $sRed1 = "This is a test."
ConsoleWrite("$sRed1 = " & $sRed1 & @LF)

Global $sBlack = CryptRDPPassword($sRed)
ConsoleWrite("$sBlack = " & $sBlack & @LF)

Global $sRed2 = UncryptRDPPassword($sBlack)
ConsoleWrite("$sRed2 = " & $sRed2 & @LF)

Func CryptRDPPassword($str)
    Local Const $CRYPTPROTECT_UI_FORBIDDEN = 0x1
    Local Const $DATA_BLOB = "int;ptr"

    Local $passStr = DllStructCreate("byte[1024]")
    Local $DataIn = DllStructCreate($DATA_BLOB)
    Local $DataOut = DllStructCreate($DATA_BLOB)
    $pwDescription = 'psw'
    $PwdHash = ""

    DllStructSetData($DataOut, 1, 0)
    DllStructSetData($DataOut, 2, 0)

    DllStructSetData($passStr, 1, StringToBinary($str,2)); UTF16 Little Endian
    DllStructSetData($DataIn, 2, DllStructGetPtr($passStr, 1))
    DllStructSetData($DataIn, 1, StringLen($str)*2)

    $return = DllCall("crypt32.dll","int", "CryptProtectData", _
                                    "ptr", DllStructGetPtr($DataIn), _
                                    "wstr", $pwDescription, _
                                    "ptr", 0, _
                                    "ptr", 0, _
                                    "ptr", 0, _
                                    "dword", $CRYPTPROTECT_UI_FORBIDDEN, _
                                    "ptr", DllStructGetPtr($DataOut))
    If @error Then Return ""

    $len = DllStructGetData($DataOut, 1)
    $PwdHash = Ptr(DllStructGetData($DataOut, 2))
    $PwdHash = DllStructCreate("byte[" & $len & "]", $PwdHash)
    Return DllStructGetData($PwdHash, 1)
EndFunc

Func UncryptRDPPassword($bin)
    Local Const $CRYPTPROTECT_UI_FORBIDDEN = 0x1
    Local Const $DATA_BLOB = "int;ptr"

    Local $passStr = DllStructCreate("byte[1024]")
    Local $DataIn = DllStructCreate($DATA_BLOB)
    Local $DataOut = DllStructCreate($DATA_BLOB)
    $pwDescription = 'psw'
    $PwdHash = ""

    DllStructSetData($DataOut, 1, 0)
    DllStructSetData($DataOut, 2, 0)

    DllStructSetData($passStr, 1, $bin)
    DllStructSetData($DataIn, 2, DllStructGetPtr($passStr, 1))
    DllStructSetData($DataIn, 1, BinaryLen($bin))

    $return = DllCall("crypt32.dll","int", "CryptUnprotectData", _
                                    "ptr", DllStructGetPtr($DataIn), _
                                    "ptr", 0, _
                                    "ptr", 0, _
                                    "ptr", 0, _
                                    "ptr", 0, _
                                    "dword", $CRYPTPROTECT_UI_FORBIDDEN, _
                                    "ptr", DllStructGetPtr($DataOut))
    If @error Then Return ""

    $len = DllStructGetData($DataOut, 1)
    $PwdHash = Ptr(DllStructGetData($DataOut, 2))
    $PwdHash = DllStructCreate("byte[" & $len & "]", $PwdHash)
    Return BinaryToString(DllStructGetData($PwdHash, 1), 2)
EndFunc
