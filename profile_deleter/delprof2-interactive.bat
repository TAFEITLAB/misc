@echo off

REM | =========================
REM | DelProf2 Interactive Command Interface
REM | =========================
REM | Purpose: 
REM |   Provide interactive interface for DelProf2's essential functions
REM | Requirements: 
REM |   - Script in same directory as delprof2.exe.
REM |   - Domain administrator credentials
REM | Author: Tim Dunn
REM | Organisation: TAFEITLAB

REM | ================
REM | VERSION HISTORY
REM | ================ 
REM | -- 2019-06-17 --
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
setlocal EnableExtensions EnableDelayedExpansion

REM | Clear screen.
cls

REM | Get date info in ISO 8601 standard date format (yyyy-mm-dd)
REM | NB: The SET function below works as follows:
REM |     VARIABLENAME:~STARTPOSITION,NUMBEROFCHARACTERS
REM |     Therefore in the string "20190327082654.880000+660"
REM |     ~0,4 translates to 2019
REM | NB: Carat (Escape character "^") needed to ensure pipe is processed as part of WMIC command instead of as part of the "for" loop
for /f %%a in ('WMIC OS GET LocalDateTime ^| find "."') do set DTS=%%a
set LOGDATE=%DTS:~0,4%-%DTS:~4,2%-%DTS:~6,2%
set LOGTIME=%DTS:~8,2%:%DTS:~10,2%:%DTS:~12,2%

REM | Logfile
REM | - Set log directory
set LOGPATH=%SYSTEMDRIVE%\Logs
REM | NB: %0 = Full file path of script
REM |     %~n0% = Script file name, no file extension
REM |     %~n0~x0 = Script file name, with file extension
REM | - Set log file name
REM |   - Include log path to ensure it is saved in the correct location.
set LOGFILE=%LOGPATH%\%~n0_%LOGDATE%.log

REM | Create log directory if does not exist
if not exist %LOGPATH% mkdir %LOGPATH%

REM | Packages and flags
REM | - Do not use trailing slashes (\).
set delprof=%~dp0\DelProf2.exe

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

REM | ============================
REM | APPLICATION Interface
REM | ============================
REM | ----------------------------
REM | Options:
REM |  - Specify computer (Wildcard * for all on domain)
REM |  - Ask for confirmation before deleting
REM |  - Check all profiles older than specified number of days
REM |  - Check all profiles matching a name
REM |  - Delete all profiles older than specified number of days
REM |  - Delete all profiles matching a name
REM | ----------------------------

REM | === Intro ===
echo %script-title% DelProf2 Interactive Command Interface %reset-colour%
echo Check and delete user profiles on the domain.
echo.

echo %warning-title-macro-inverse%
echo This script must be run with domain administrator rights.
echo Ensure script is in the same directory as DelProf2.exe
echo.

echo %info% -- Acknowledgements -- %reset-colour%
echo.
echo %underline%DelProf2%reset-colour% copyright Helge Klein
echo https://helgeklein.com/free-tools/delprof2-user-profile-deletion-tool/
echo.
echo This script uses a modified version of %underline%fchooser.bat%reset-colour%
echo for file browsing functions.
echo https://stackoverflow.com/a/15885133
echo.
echo %info% ---------------------- %reset-colour%
echo.

:choose-mode
echo %section-title% Choose a mode %reset-colour%
echo Enter %user-option% 1 %reset-colour% to check existing profile^(s^)
echo  before proceeding to the delete option
echo Enter %user-option% 2 %reset-colour% to delete profile^(s^) without checking
echo Enter %user-option% 3 %reset-colour% to quit
echo.
:choose-mode-input
set "choose-mode="
set /p choose-mode=%request-input-macro%
echo.

if %choose-mode%==1 goto check-profiles
if %choose-mode%==2 goto delete-profiles
if %choose-mode%==3 goto close-script
if not errorlevel 1 (
	echo %warning-text%Invalid input.%reset-colour%
	echo.
	goto choose-mode-input
)

REM | === Check Mode ===
REM | Intro
:check-profiles
echo %section-title% Check for profiles %reset-colour%
echo Enter %user-option% 1 %reset-colour% to check all workstations
echo Enter %user-option% 2 %reset-colour% to create and check a custom list.
echo Enter %user-option% 3 %reset-colour% to quit.
echo.
:choose-pc-list
set "choose-pc-list="
set /p choose-pc-list=%request-input-macro%
echo.

if %choose-pc-list%==1 (
	set pc-list==list-pc-all.txt
	goto choose-by-age-intro
	)
if %choose-pc-list%==2 (
	set pc-list==list-pc-custom.txt
	goto custom-pc-list
	)
if %choose-list%==3 goto end
if not errorlevel 1 (
	echo %warning-text%Invalid input.%reset-colour%
	echo.
	goto choose-pc-list
)

REM | Input custom PC list
:custom-pc-list
REM | if not exist list-pc-custom echo NUL>list-pc-custom.txt
echo %section-subtitle% Enter a list of PCs to check. Input one per line, eg: %reset-colour%
echo    PC-01
echo    PC-01
echo    PC-03
echo.
echo %warning-text% Important^! %reset-colour%
echo Ensure file is saved in same directory as this script.
echo.
echo Opening Windows Notepad...
echo.
notepad list-pc-custom.txt
echo.
goto choose-by-age-intro

REM | Choose by age?
:choose-by-age-intro
echo %section-subtitle% Do you want to find profiles by age? %reset-colour%
echo Enter %user-option% y %reset-colour% for Yes
echo Enter %user-option% n %reset-colour% for No
echo Enter %user-option% q %reset-colour% to quit
echo.
:choose-by-age
set /p choose-by-age=%request-input-macro%
echo.
if /I %choose-by-age%==y goto set-age
if /I %choose-by-age%==n goto choose-by-string-intro
if /I %choose-by-age%==q goto end
echo.
if not errorlevel 1 (
	echo %warning-text%Invalid input.%reset-colour%
	echo.
	goto choose-by-age
)


REM | User input: Set age
:set-age
echo %section-subtitle% Choose age of profiles%reset-colour%
set "profile-age="
set /p profile-age=%request-input-text%Enter the age of profile in number of days: %reset-colour%
echo.
goto choose-by-string-intro

REM | Check by string?
:choose-by-string-intro
echo %section-subtitle% Do you want to find profiles matching a string?%reset-colour%
echo Enter %user-option% y %reset-colour% for Yes
echo Enter %user-option% n %reset-colour% for No
echo Enter %user-option% q %reset-colour% to quit
:choose-by-string
set /p choose-by-string=%request-input-macro%
echo.
if /I %choose-by-string%==y goto set-string
if /I %choose-by-string%==n goto check-commands
if /I %choose-by-string%==q goto end
echo.

if not errorlevel 1 (
	echo %warning-text%Invalid input.%reset-colour%
	echo.
	goto choose-by-string
)

REM | User input: Set string
:set-string
echo %section-subtitle% Find profiles with matching names%reset-colour%
echo Input the entire name to match exactly.
echo Enclose a string in wildcards to find all names containing that sequence, e.g.: 
echo   ^*smit^* will return john.smith, mary.smitty, etc.
set "profile-string="
set /p profile-string=%request-input-text%Enter the name: %reset-colour%
echo.
goto check-commands

REM | Commands
:check-commands
echo.
echo %inverse% Checking user options... %reset-colour%
echo.

REM | -- Redirect according to user input
:if-profile-age
if defined profile-age (
	goto if-profile-age-and-string
	) else (
	goto if-profile-string
	)

:if-profile-string
if defined profile-string	(
	goto check-by-string
	) else (
	goto check-all
	)

:if-profile-age-and-string
if defined profile-string (
	goto check-by-age-and-string
	) else (
	goto check-by-age
	)

REM | -- Predefined workstation list
:check-all
echo %inverse% Checking all workstations... %reset-colour%
echo.
for /F "tokens=*" %%A in (%pc-list%) do (
	%delprof% /l /u /c:\\%%A /ntuserini /i
	echo.
	echo ^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=
	echo.
	)
goto end

:check-by-age
for /F "tokens=*" %%A in (%pc-list%) do (
	%delprof% /l /u /c:\\%%A /d:%profile-age% /ntuserini
	echo.
	echo ^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=
	echo.
	)
goto end

:check-by-string
for /F "tokens=*" %%A in (%pc-list%) do (
	%delprof% /l /u /c:\\%%A /ntuserini /id:%profile-string%
	echo.
	echo ^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=
	echo.
	)
goto end

:check-by-age-and-string
for /F "tokens=*" %%A in (%pc-list%) do (
	%delprof% /l /u /d:%profile-age% /c:\\%%A /ntuserini /id:%profile-string%
	echo.
	echo ^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=
	echo.
	)
goto end

REM | === Delete Mode ===
:delete-profiles
echo %section-title% Delete profiles %reset-colour%
echo Enter %user-option% 1 %reset-colour% to delete from all workstations
echo Enter %user-option% 2 %reset-colour% to create and delete from a custom list.
echo Enter %user-option% 3 %reset-colour% to quit.
echo.

:delete-pc-list
set "delete-pc-list="
set /p delete-pc-list=%request-input-macro%
echo.

if %delete-pc-list%==1 (
	set pc-list==list-pc-all.txt
	goto delete-by-age-intro
	)
if %delete-pc-list%==2 (
	set pc-list==list-pc-custom.txt
	goto custom-delete-pc-list
	)
if %delete-list%==3 goto end
if not errorlevel 1 (
	echo %warning-text%Invalid input.%reset-colour%
	echo.
	goto delete-pc-list
)

REM | Input custom PC list
:custom-delete-pc-list
REM | if not exist list-pc-custom echo NUL>list-pc-custom.txt
echo Enter a list of PCs to check. Input one per line, eg:
echo    PC-01
echo    PC-01
echo    PC-03
echo.
echo %warning-text% Important^! %reset-colour%
echo Ensure file is saved in same directory as this script.
echo.
echo Opening Windows Notepad...
echo.
notepad list-pc-custom.txt
echo.
goto delete-by-age-intro

REM | Delete by age?
:delete-by-age-intro
echo %section-subtitle% Do you want to delete profiles by age? %reset-colour%
echo Enter %user-option% y %reset-colour% for Yes
echo Enter %user-option% n %reset-colour% for No
echo Enter %user-option% q %reset-colour% to quit
echo.
:delete-by-age
set /p delete-by-age=%request-input-macro%
echo.
if /I %delete-by-age%==y goto set-delete-age
if /I %delete-by-age%==n goto delete-by-string-intro
if /I %delete-by-age%==q goto end
echo.
if not errorlevel 1 (
	echo %warning-text%Invalid input.%reset-colour%
	echo.
	goto delete-by-age
)


REM | User input: Set deletion age
:set-delete-age
echo %section-subtitle% Choose age of profiles%reset-colour%
set "profile-delete-age="
set /p profile-delete-age=%request-input-text%Enter the age of profile in number of days: %reset-colour%
echo.
goto delete-by-string-intro

REM | Delete by string?
:delete-by-string-intro
echo %section-subtitle% Do you want to find profiles matching a string?%reset-colour%
echo Enter %user-option% y %reset-colour% for Yes
echo Enter %user-option% n %reset-colour% for No
echo Enter %user-option% q %reset-colour% to quit
:delete-by-string
set /p delete-by-string=%request-input-macro%
echo.
if /I %delete-by-string%==y goto set-delete-string
if /I %delete-by-string%==n goto delete-commands
if /I %delete-by-string%==q goto end
echo.

if not errorlevel 1 (
	echo %warning-text%Invalid input.%reset-colour%
	echo.
	goto delete-by-string
)

REM | User input: Set deletion string
:set-delete-string
echo %section-subtitle% Find profiles with matching names%reset-colour%
echo Input the entire name to match exactly.
echo Enclose a string in wildcards to find all names containing that sequence, e.g.: 
echo   ^*smit^* will return john.smith, mary.smitty, etc.
set "profile-delete-string="
set /p profile-delete-string=%request-input-text%Enter the name: %reset-colour%
echo.
goto delete-commands

REM | Commands
:delete-commands
echo.
echo %section-subtitle% Checking user options... %reset-colour%
echo.

REM | -- Redirect according to user input
:if-profile-delete-age
if defined profile-delete-age (
	goto if-profile-delete-age-and-string
	) else (
	goto if-profile-delete-string
	)

:if-profile-delete-string
if defined profile-delete-string	(
	goto delete-by-string
	) else (
	goto delete-all
	)

:if-profile-delete-age-and-string
if defined profile-delete-string (
	goto delete-by-age-and-string
	) else (
	goto delete-by-age
	)

REM | Begin checking
:check-all
echo %section-subtitle% Checking selected workstations... %reset-colour% 
echo.
for /F "tokens=*" %%A in (%pc-list%) do (
	%delprof% /l /u /c:\\%%A /ntuserini /i
	echo.
	echo ^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=
	echo.
	)
goto end

:check-by-age
for /F "tokens=*" %%A in (%pc-list%) do (
	%delprof% /l /u /c:\\%%A /d:%profile-delete-age% /ntuserini
	echo.
	echo ^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=
	echo.
	)
goto end

:check-by-string
for /F "tokens=*" %%A in (%pc-list%) do (
	%delprof% /l /u /c:\\%%A /ntuserini /id:%profile-delete-string%
	echo.
	echo ^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=
	echo.
	)
goto end

:check-by-age-and-string
for /F "tokens=*" %%A in (%pc-list%) do (
	%delprof% /l /u /d:%profile-delete-age% /c:\\%%A /ntuserini /id:%profile-delete-string%
	echo.
	echo ^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=
	echo.
	)
goto end

REM | ============================
REM | CLEAR ENVIRONMENT and EXIT
REM | ============================
:end
echo %section-title% Do you want to start again or choose another mode? %reset-colour%
echo Enter %user-option% y %reset-colour% for Yes
echo Enter %user-option% n %reset-colour% for No
echo.
set /p start-again=%request-input-macro%
echo.
if /I %start-again%==y goto choose-mode
if /I %start-again%==n goto close-script
echo.

:close-script
REM | Reset current working directory.
popd

REM | Wait for confirmation to close.
echo.
pause>nul|set/p=%warning-inverse%Press any key to ^exit ...%reset-colour%