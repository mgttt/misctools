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
		echo with(WScript^){if(CreateObject('Scripting.FileSystemObject'^).FileExists(arguments(1^)^)^){Quit(^);}with(CreateObject('MSXML2.ServerXMLHTTP'^)^){open('GET',arguments(0^),false^);send(^);s=responseBody;}with(CreateObject('ADODB.Stream'^)^){Open(^);Type=1;Write(s^);Position=0;SaveToFile(arguments(1^),2^);Close(^);}} > dl.js
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
