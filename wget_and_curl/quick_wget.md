```
set f="%random%.js" && echo with(WScript){if(CreateObject("Scripting.FileSystemObject").FileExists(arguments(1))){Quit();}with(CreateObject("MSXML2.ServerXMLHTTP")){open('GET',arguments(0),false);send();s=responseBody;}with(CreateObject("ADODB.Stream")){Open();Type=1;Write(s);Position=0;SaveToFile(arguments(1),2);Close();}} >%f% && cscript /nologo %f% https://partnernetsoftware.com/wget64.1.20.3.exe w.exe && del %f% /f /q && dir w.exe
```

Yup, u now can do anything start from w.exe

for example 
> w -qO - https://www.google.com/
> w -n 5 https://github.com/shadowsocks/go-shadowsocks2/releases/download/v0.0.11/shadowsocks2-win64.zip
> w -n 5 https://download.zerotier.com/dist/ZeroTier%20One.msi

or

> w -q some-remote-file-url -o local-file-installer.exe && local-file-installer.exe

for example

> set f="%random%.js" && echo with(WScript){if(CreateObject("Scripting.FileSystemObject").FileExists(arguments(1))){Quit();}with(CreateObject("MSXML2.ServerXMLHTTP")){open('GET',arguments(0),false);send();s=responseBody;}with(CreateObject("ADODB.Stream")){Open();Type=1;Write(s);Position=0;SaveToFile(arguments(1),2);Close();}} >%f% && cscript /nologo %f% http://jump.ws/wget.exe w.exe && del %f% /f /q && w -q http://jump.ws/php5444.bat -O php5444.bat && php5444.bat -m


finally:
```
@echo off
set ndl=0
set p0=%~dp0
set ph=%p0%php5444tool\php.exe
set st=0
:st

if exist "%ph%" (
	if "%1" EQU "" (%ph% test.php) else (%ph% %1 %2 %3 %4 %5 %6 %7 %8 %9)
) else (
	if %st% NEQ 1 (
		if exist dl.js del /f /q dl.js
		@set ss="with(WScript){if(CreateObject('Scripting.FileSystemObject').FileExists(arguments(1))){Quit();}with(CreateObject('MSXML2.ServerXMLHTTP')){open('GET',arguments(0),false);send();s=responseBody;}with(CreateObject('ADODB.Stream')){Open();Type=1;Write(s);Position=0;SaveToFile(arguments(1),2);Close();}}"
		@for /f "delims=" %%a in (%ss%) do echo %%a > dl.js

		cscript /nologo dl.js "http://jump.ws/wget.exe" "wget.exe"
		if exist dl.js del /f /q dl.js

		wget -c -O php5444mini4tool.exe http://jump.ws/php5444mini4tool.exe
		mkdir php5444tool
		cd php5444tool
		..\php5444mini4tool.exe -x
		cd ..
		copy php5444tool\test.php .\
		del /f /q php5444mini4tool.exe
		set st=1 && goto st
	)
)
:ed
```
---

PLEASE FOLLOW ME IF YOU LIKE THIS
