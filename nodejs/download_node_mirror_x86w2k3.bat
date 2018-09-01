set f="%random%.js"

echo with(WScript){if(CreateObject("Scripting.FileSystemObject").FileExists(arguments(1))){Quit();}with(CreateObject("MSXML2.ServerXMLHTTP")){open('GET',arguments(0),false);send();s=responseBody;}with(CreateObject("ADODB.Stream")){Open();Type=1;Write(s);Position=0;SaveToFile(arguments(1),2);Close();}} >%f%

cscript /nologo %f% https://npm.taobao.org/mirrors/node/v5.12.0/win-x86/node.exe node.exe

del %f% /f /q

pause


