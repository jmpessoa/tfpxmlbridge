@echo off
SET THEFILE=project1.exe
echo Linking %THEFILE%
C:\lazarus\fpc\2.6.2\bin\i386-win32\ld.exe -b pei-i386 -m i386pe  --gc-sections   --subsystem windows --entry=_WinMainCRTStartup    -o project1.exe link.res
if errorlevel 1 goto linkend
C:\lazarus\fpc\2.6.2\bin\i386-win32\postw32.exe --subsystem gui --input project1.exe --stack 16777216
if errorlevel 1 goto linkend
goto end
:asmend
echo An error occured while assembling %THEFILE%
goto end
:linkend
echo An error occured while linking %THEFILE%
:end
