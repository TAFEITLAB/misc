@echo off

REM | =========================
REM | ESXi Host interactive backup for TAFEITLAB
REM | =========================
REM | Purpose: Silently install PACKAGE via PDQ Deploy.
REM | Requirements: 
REM |   - Script in same directory as plink64.exe.
REM |   - Script in same directory as wget.exe.
REM |   - Script in same directory as backup.ini.
REM |   - Domain admin credentials.
REM | Author: Tim Dunn
REM | Organisation: TAFEITLAB

REM | ================
REM | VERSION HISTORY
REM | ================ 
REM | -- 2019-06-19 --
REM | First complete version.
REM | ----------------

REM | ================================
REM | PREPARE ENVIRONMENT FOR INSTALL
REM | ================================

REM | Set location of batch file as current working directory
REM | NB: Breakdown of %~dp0:
REM |     % = start variable
REM |     ~ = remove surrounding quotes
REM |     0 = filepath of script
REM |     d = Expand 0 to drive letter only
REM |     p = expand 0 to path only
REM |     Therefore %~dp0 = 
REM |        Get current filepath of script (drive letter and path only)
REM |        No quote marks.
pushd "%~dp0"

REM | Set local environment
setlocal enabledelayedexpansion

REM | Clear screen.
cls

REM | Set interface colour scheme and macros
REM |  - Colours
set reset-colour=[0m
set script-title=[7;92m
REM -- set mode-title=[7;96m
REM -- set mode-subtitle=[96m
set section-title=[7;96m
set section-subtitle=[96m
set warning-text=[91m
set warning-inverse=[7;91m
set info=[92m
REM -- set request-input-title=[7;36m
set request-input-text=[36m
set user-option=[95m
set inverse=[7m
set underline=[4m
REM |  - Macros
set request-input-macro=%request-input-text%Enter your selection: %reset-colour%
set warning-title-macro=[91m Warning! [0m
set warning-title-macro-inverse=[7;91m Warning! [0m

REM | Set universal variables
set username=root
set command-file=backup.txt
set output-file=output.txt
set url-file=url.txt
set url-converted-file=url-converted.txt
set esxi-01-hostname=EXAMPLE-01
set esxi-02-hostname=EXAMPLE-02
set esxi-01-ip=192.168.1.1
set esxi-02-ip=192.168.1.2

REM | Destroy then create output file
del %output-file%
echo. > %output-file%

REM | ============================
REM | APP
REM | ============================
:intro
echo %script-title% ESXi Configuration Backup
echo  Interactive Script       %reset-colour%
echo.
echo %info%Create and download backups of ESXi host configurations%reset-colour%
echo.
echo %warning-title-macro%
echo This script uses the root user credentials on the host.
echo If you do not have root access to the server,
echo quit at the following screen.
echo.
echo %info% -- Acknowledgements -- %reset-colour%
echo.
echo This script uses a modified version of %underline%fchooser.bat%reset-colour%
echo for file browsing functions.
echo https://stackoverflow.com/a/15885133
echo.
echo This script relies on the following third-party applications:
echo.
echo     The plink64.exe component of PuTTY
echo     https://www.chiark.greenend.org.uk/~sgtatham/putty/
echo.
echo     The executable from the PortableApps edition of WGET for Windows
echo     https://portableapps.com/apps/internet/winwget_portable
echo.
echo %info% ---------------------- %reset-colour%
echo.

REM | Server Status
echo %section-title% Server status check %reset-colour%
echo.
echo %section-subtitle% Checking ESXi-02... %reset-colour%
ping -n 1 %esxi-01-ip%
echo.
echo %section-subtitle% Checking ESXi-02.... %reset-colour%
ping -n 1 %esxi-02-ip%
echo.
REM |  - Quit or not
:quit-or-not
echo %section-subtitle% Do you want to continue? %reset-colour%
echo Enter %user-option% y %reset-colour% to continue
echo Enter %user-option% n %reset-colour% to quit
echo.
:continue-choice
set /p delete-by-age=%request-input-macro%
echo.
if /I %delete-by-age%==y goto begin-backup
if /I %delete-by-age%==n goto close-script
echo.
if not errorlevel 1 (
	echo %warning-text%Invalid input.%reset-colour%
	echo.
	goto continue-choice
)


REM |  - Get user input: Password
:begin-backup
echo %section-subtitle% Begin backup procedure %reset-colour%
:password-prompt
set "PasswordPrompt=powershell -Command "$pword = read-host '%request-input-text%Enter Password %reset-colour%' -AsSecureString ; ^
    $BSTR=[System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($pword); ^
        [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)""
for /f "usebackq delims=" %%p in (`%PasswordPrompt%`) do set password=%%p
echo.

REM | --- ESXi-01 ---
:esxi-01
echo %section-subtitle% Performing task on %esxi-01-hostname%... %reset-colour%
echo.
REM |  - Set host address
set "hostname="
set hostname=%esxi-01-hostname%
set "hostip="
set hostip=%esxi-01-ip%
REM |  - Run commands via plink64
plink64 -ssh -pw %password% -batch %username%@%hostip% -m %command-file% >> %output-file%
echo.

REM | --- ESXi-02 ---
:esxi-02
echo %section-subtitle% Performing task on %esxi-02-hostname%... %reset-colour%
echo.
REM |  - Set host address
set "hostname="
set hostname=%esxi-02-hostname%
set "hostip="
set hostip=%esxi-02-ip%
echo.
REM |  - Run commands via plink64
plink64 -ssh -pw %password% -batch %username%@%hostip% -m %command-file% >> %output-file%
echo.

REM | Check success
echo %section-subtitle%Did the attempt succeed?%reset-colour%
echo Failure may be due to an incorrect password.
:ask-if-succeeded
echo Enter %user-option% 1 %reset-colour% to try again
echo Enter %user-option% 2 %reset-colour% to continue
echo Enter %user-option% 3 %reset-colour% to quit
set "retry="
set /p retry=%request-input-macro%
echo.

if %retry%==1 goto password-prompt
if %retry%==2 goto save-bundles
if %retry%==3 goto close-script
if not errorlevel 1 (
	echo %warning-text%Invalid input.%reset-colour%
	echo.
	goto ask-if-succeeded
)
echo.

REM | Save configBundles
:save-bundles
echo %section-title% Save the configBundles %reset-colour%
echo.

REM |  - Choose a save location via fchooser (modified)
:choose-save-location
echo %user-input-text% Choose save location %reset-colour%
set "psCommand="(new-object -COM 'Shell.Application')^
.BrowseForFolder(0,'Please choose a folder.',0,0).self.path""
for /f "usebackq delims=" %%I in (`powershell %psCommand%`) do set "folder=%%I"
echo.
echo Files will be saved to %underline%!folder!%reset-colour%
echo.

REM | Destroy and create URL files

REM |  - Destroy files
if exist %url-file% del %url-file%
if exist %url-converted-file% del %url-converted-file%

REM |  - Convert output-file to url-file
echo.
for /f "tokens=7 delims= " %%o in (%output-file%) do (
echo %%o >> %url-file%
)
echo.

REM |  - Convert url-file to url-converted-file
for /f "tokens=* delims=" %%f in (%url-file%) do (
	set web-address-orig=%%f
	set web-address-modified=!web-address-orig:~9,100!
	for /l %%a in (198,1,199) do (
	set /a ip=%%a
	set /a ip+=1
	echo http^:^/^/10.0.1.!ip!^/!web-address-modified! >> %url-converted-file%
	)
)

REM | Set download URLs
set /p esxi-01-configBundle= < url-converted.txt
echo %esxi-01-hostname% configBundle URL^:
echo %esxi-01-configBundle%
echo.

(for /L %%i in (1,1,4) do set /p esxi-02-configBundle=) < url-converted.txt
echo %esxi-02-hostname% configBundle URL^:
echo %esxi-02-configBundle% 
echo.

REM | Use wget portable and fchooser to download bundles
REM |  - Download ESXi-01 configBundle
:download-esxi-01-configbundle
echo Downloading %esxi-01-hostname% configBundle to !folder!...
echo.

wget --directory-prefix=!folder! --no-check-certificate %esxi-01-configBundle%
echo.

::if not errorlevel 0 (
::echo.
::echo %warning-text%Download failed.%reset-colour%
::echo Enter %user-option% 1 %reset-colour% to try again.
::echo Enter %user-option% 2 %reset-colour% to continue.
::set "retry-dl-esxi-01="
::set /p retry-dl-esxi-01=%request-input-macro%
::echo.

::	if %retry-dl-esxi-01%==1 goto download-esxi-01-configbundle
::	if %retry-dl-esxi-01%==2 goto download-esxi-02-configbundle
::	if not errorlevel 1 (
::		echo %warning-text%Invalid input.%reset-colour%
::		echo.
::		goto ask-if-succeeded
::	)
::)

echo.

REM |  - Download ESXi-02 configBundle
:download-esxi-02-configbundle
echo Downloading %esxi-02-hostname% configBundle to !folder!...
echo.

wget --directory-prefix=!folder! --no-check-certificate %esxi-02-configBundle%
echo.

::if not errorlevel 0 (
::echo.
::echo %warning-text%Download failed.%reset-colour%
::echo Enter %user-option% 1 %reset-colour% to try again.
::echo Enter %user-option% 2 %reset-colour% to continue.
::set "retry-dl-esxi-02="
::set /p retry-dl-esxi-02=%request-input-macro%
::echo.

::	if %retry-dl-esxi-02%==1 goto download-esxi-02-configbundle
::	if %retry-dl-esxi-02%==2 goto close-script
::	if not errorlevel 1 (
::		echo %warning-text%Invalid input.%reset-colour%
::		echo.
::		goto ask-if-succeeded
::	)
::)

echo. 

REM | ============================
REM | CLEAR ENVIRONMENT and EXIT
REM | ============================

REM | Reset current working directory.
:close-script
popd
echo %warning-text%Closing script...%reset-colour%
echo.
::timeout /t 5 /nobreak
echo.
endlocal

REM | Return exit code to PDQ Deploy.
:end
pause