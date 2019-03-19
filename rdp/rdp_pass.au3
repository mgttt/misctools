Func CryptRDPPassword2($str)
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

Func CryptRDPPassword($str)
    Const $CRYPTPROTECT_UI_FORBIDDEN = 0x1
    Const $DATA_BLOB = "int;ptr"

    Dim $passStr = DllStructCreate("byte[1024]")
    Dim $DataIn = DllStructCreate($DATA_BLOB)
    Dim $DataOut = DllStructCreate($DATA_BLOB)
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
    $encodeStr = ""
    For $x = 1 To $len
            $encodeStr &= Hex(DllStructGetData($PwdHash, 1, $x),2)
    Next
    Return $encodeStr
EndFunc

$argc = $CmdLine[0]

$pass=""
if $argc>0 then
	$pass=$CmdLine[1]
$pass2=CryptRDPPassword($pass)
;MsgBox(0,$pass,$pass2)
ConsoleWrite($pass2)
endif

