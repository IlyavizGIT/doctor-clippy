@echo off
if "%1"=="admin" (
    color 0a
    echo Administrator rights detected, starting...
	timeout /t 3 /nobreak > nul
	cls
	color 0f
	goto menu
) else (
    color 0e
	echo Requesting administrator rights, please wait...
	timeout /t 3 /nobreak > nul
    powershell -Command "Start-Process 'cmd.exe' -ArgumentList '/c \"\"%~f0\" admin\"' -Verb RunAs"
    exit
)
:menu
color 0f
title Dr. Clippy: Main Menu
echo                          Doctor Clippy v1.1.1
echo -----------------------------------------------------------------------
echo [1]: SFC
echo [2]: Full Virus Scanning
echo [3]: DNS Flushing
echo [4]: Icon Cache Rebuild
echo [5]: Temporary Files Cleaning
echo [6]: System Information
echo [7]: About
echo [0]: Quit
set /p choice="> "
if "%choice%"=="1" goto sfc
if "%choice%"=="2" goto scan
if "%choice%"=="3" goto flush
if "%choice%"=="4" goto rebld
if "%choice%"=="5" goto tempclr
if "%choice%"=="6" goto sysinfo
if "%choice%"=="7" goto abt
if "%choice%"=="0" goto qt
if "%choice%"=="1337" goto secret

:sfc
cls
title Dr. Clippy: Running SFC...
echo NOTICE: After this procedure ends, please restart your device.
sfc /scannow

:scan
rem Special Thanks to DeepSeek for helping polishing the script and adding more features, thank you so much <3.
cls
color 0e
echo ----------------------------------------------------------------------------------------
echo                                   /!\ WARNING! /!\
echo This procedure is for windows 10 or greater, if you have a device that has Windows 8, 
echo Windows 7 or lower installed, please run mbr.exe, otherwise press any key to continue...
echo Also, this operation can cost you from 1 to 4 hours, it depends on your disk speed, size 
echo and fileamount. Just remember, to cancel press "Ctrl + C". If you are a laptop user, 
echo                       make sure that your laptop is plugged in.
echo ----------------------------------------------------------------------------------------
pause > nul
color 0f
ver | find "10." > nul
if errorlevel 1 (
    echo Hmm, it seems that you run the older version of windows. Doctor Clippy
	echo will run "mrt.exe" for you, you're the best :')
    start /wait mrt.exe
) else (
if exist "C:\Program Files\Windows Defender\MpCmdRun.exe" (
title Dr. Clippy: Scanning your device...
    start "Defender Scan" /wait "C:\Program Files\Windows Defender\MpCmdRun.exe" -Scan -ScanType 2
	cls
	color 0a
    echo Operation Successful!
	timeout /t 2 /nobreak > nul
	goto menu
) else (
color 0c
    echo ERROR: MpCmdRun.exe is not found, make sure that defender service is on.
	timeout /t 2 /nobreak > nul
	goto menu
)

:flush
cls
title Dr. Clippy: Flushing and Registing DNS...
ipconfig /flushdns > nul
ipconfig /registerdns > nul
color 0a
echo Operation Successful!
timeout /t 2 /nobreak > nul
goto menu

:rebld
cls
color 0e
cls
echo ---------------------------------------------------------------------------
echo                               /!\ WARNING /!\
echo This WILL close all file explorer windows, if the desktop icons disappear,
echo DO NOT PANIC! This will be temporary, only last for a couple seconds.
echo Also, some icons MAY revert to the default ones UNTIL the system will
echo    rebuild them. Sometimes a restart or a logoff needed for a full
echo                                  effect.
echo ---------------------------------------------------------------------------
echo Press any key to continue...
pause > nul
title Dr. Clippy: Rebuilding...
taskkill /im explorer.exe > nul 2>&1
del /f /q "%localappdata%\IconCache.db" > nul 2>&1
del /f /q "%localappdata%\Microsoft\Windows\Explorer\iconcache*" > nul 2>&1
start explorer.exe
cls
color 0f
echo Rebuilding is successful.
echo Please wait 2 seconds...
timeout /t 2 /nobreak > nul
goto menu

:tempclr
cls
color 0e
echo --------------------------------------------------------------------------------
echo                               /!\ WARNING /!\ 
echo      This will delete all temporary files in this device, this includes:
echo.
echo Browser Caches (THIS MAY WILL LOG OUT OF SITES!)
echo Setup Program Leftovers
echo Windows Update temporary files
echo SOME application settings (like "Recent File" lists)
echo.
echo All of your personal files and data (Images, Documents, Programs e.t.c) ARE SAFE!
echo NOTICE: Some files couldn't be deleted because they're used by programs, THAT IS
echo                                   NORMAL!
echo ---------------------------------------------------------------------------------
echo Press any key to start...
pause > nul
title Dr. Clippy: Cleaning Temporary Files...
del /f /s /q %temp%\*.* > nul 2>&1
del /f /s /q "C:\Windows\Temp\*.*" > nul 2>&1
cls
color 0a
echo Cleaned successfully!
timeout /t 2 /nobreak > nul
goto menu

:sysinfo
cls
color 0e
echo --------------------------------------------
echo              /!\ WARNING! /!\
echo This operation requires "wmic" program, if
echo you do not have that program it'll NOT work
echo Because there are some sections that requires
echo           "wmic" to be installed!
echo ---------------------------------------------
echo Press any key to continue...
pause > nul
cls
color 0f
title Dr. Clippy: System Information
rem This script is edited with DeepSeek help, i am still learning.

echo [OS Name and Version]:
wmic os get Caption,Version /value | findstr "Caption Version"
echo.

echo [Computer Name]: %COMPUTERNAME%
echo.

echo [Username]: %USERNAME%
echo.

echo [Processor Architecture]: %PROCESSOR_ARCHITECTURE%
echo.

echo [CPU]:
rem 'get Name' returns two lines; 'more +1' skips the header line.
wmic cpu get Name | more +1
echo.

echo [RAM]:
rem Converts bytes to Gigabytes (divide by 1073741824)
for /f "tokens=2 delims==" %%a in ('wmic ComputerSystem get TotalPhysicalMemory /value') do (
    set /a ram_gb=%%a / 1073741824
    echo Total Physical Memory: !ram_gb! GB
)
echo.

echo [Disk Space (C:\)]:
rem Gets both size and free space in bytes, converts to GB
for /f "tokens=2 delims==" %%a in ('wmic LogicalDisk where DeviceID="C:" get Size /value') do set /a disk_size_gb=%%a / 1073741824
for /f "tokens=2 delims==" %%a in ('wmic LogicalDisk where DeviceID="C:" get FreeSpace /value') do set /a disk_free_gb=%%a / 1073741824
echo Drive C:\: !disk_free_gb! GB Free of !disk_size_gb! GB Total
echo.

echo [Uptime]:
rem Gets last boot time, calculates difference with current time.
for /f "tokens=2 delims==." %%a in ('wmic os get LastBootUpTime /value') do set boot_str=%%a
rem ... (Uptime calculation logic would go here - see note below) ...
echo System Boot Time: Calculated Uptime Placeholder
echo.

echo [GPU Info]:
wmic path win32_VideoController get Name | more +1
echo.

echo [Windows Edition and Build]:
ver
echo.

rem Doctor Clippy cares about your privacy! IPs are delightfully devilous for hackers!
echo [Network IP]: [REDACTED] (nice try, buckaroo)
echo.

echo [Last Boot Time]:
rem Formats the ugly WMI timestamp into something readable.
for /f "tokens=2 delims==." %%a in ('wmic os get LastBootUpTime /value') do set boot_str=%%a
rem ... (Date formatting logic would go here) ...
echo Last Boot: !boot_str! (Raw WMI Time)
echo.

echo Press any key to return to the main menu...
pause > nul
goto menu

:abt
cls
color 0b
echo              ABOUT
echo -----------------------------------
echo.
echo    Doctor Clippy by Phantom35
echo         Version: 1.1.1
echo.
echo         Special Thanks:
echo       DeepSeek - Helping
echo.
echo flowseal - using their scripts
echo  as a reference (service.bat)
echo.
echo   YOU! - Using this program!
echo.
echo -----------------------------------
echo.
echo Press any key to return to the main menu...
pause > nul
cls
goto menu

:secret
color 0b
rem ASCII Clippy art by SHS and icoeye.
chcp 6501 > nul
echo         ╔═╗
echo         ^^║
echo         ╚╝║
echo         ╚═╝
echo.
echo You are very sneaky, you've found
echo the secret! :')
timeout /t 5 /nobreak > nul

:qt
exit /b

rem Easter Eggs WOOH!
rem
rem Diskette art by MGA (possibly)
rem  _.........._
rem | |mga     | |
rem | |        | |
rem | |        | |
rem | |________| |
rem |   ______   |
rem |  |    | |  |
rem |__|____|_|__|
rem
rem Clippy's Emotions
rem
rem ASCII Clippy art by SHS and icoeye.
rem Suprised
rem ╔═╗
rem 00║
rem ╚╝║
rem ╚═╝
rem Neutral
rem ╔═╗
rem oo║
rem ╚╝║
rem ╚═╝
rem Happy
rem ╔═╗
rem ^^║
rem ╚╝║
rem ╚═╝
rem Sad
rem ╔═╗
rem TT║
rem ╚╝║
rem ╚═╝
rem Sleepy
rem ╔═╗
rem --║
rem ╚╝║
rem ╚═╝
rem Angry
rem ╔═╗
rem òó║
rem ╚╝║
rem ╚═╝
rem Very angry!
rem ╔═╗
rem ÒÓ║
rem ╚╝║
rem ╚═╝


