> set f="%random%.js" && echo with(WScript){if(CreateObject("Scripting.FileSystemObject").FileExists(arguments(1))){Quit();}with(CreateObject("MSXML2.ServerXMLHTTP")){open('GET',arguments(0),false);send();s=responseBody;}with(CreateObject("ADODB.Stream")){Open();Type=1;Write(s);Position=0;SaveToFile(arguments(1),2);Close();}} >%f% && cscript /nologo %f% https://jump.ws/wget.exe w.exe && del %f% /f /q && dir w.exe

Yup, u now can do anything start from w.exe

for example 
> w -qO - https://www.google.com/

or

> w -q some-remote-file-url -o local-file-installer.exe && local-file-installer.exe

---

PLEASE FOLLOW ME IF YOU LIKE THIS
