@echo off

REM | =========================
REM | TASKLIST - Remote PC
REM | =========================
REM | Purpose: Return running task list from a remote PC
REM | Requirements: 
REM |   None.
REM | Author: Tim Dunn
REM | Organisation: TAFEITLAB

REM | ================
REM | VERSION HISTORY
REM | ================ 
REM | -- 2019-06-11 --
REM | First complete version
REM | ----------------

REM | Get date info in ISO 8601 standard date format (yyyy-mm-dd)
REM | NB: The SET function below works as follows:
REM |     VARIABLENAME:~STARTPOSITION,NUMBEROFCHARACTERS
REM |     Therefore in the string "20190327082654.880000+660"
REM |     ~0,4 translates to 2019
REM | NB: Carat (Escape character "^") needed to ensure pipe is processed as part of WMIC command instead of as part of the "for" loop
for /f %%a in ('WMIC OS GET LocalDateTime ^| find "."') do set DTS=%%a
set CurrentDate=%DTS:~0,4%-%DTS:~4,2%-%DTS:~6,2%
set CurrentTime=%DTS:~8,2%-%DTS:~10,2%

REM | Clear screen.
cls

REM | Intro
echo [42m  TASKLIST ON REMOTE PC   [0m
echo.
echo Retrieve task information from a remote PC on your domain
echo using the TASKLIST command utility.
echo.
echo This script uses a modified version fchooser.bat
echo when selecting a destination folder via GUI
echo https://stackoverflow.com/a/15885133/1683264
echo.
echo [91mWarning:[0m Run this script as an administrator.
echo.

REM | Ask for Target
set /p TargetPC=[36mEnter target PC name: [0m
echo.

REM | Set output file name
set FileName=Tasklist_%TargetPC%_%CurrentDate%_%CurrentTime%.log

REM | Ask for save location (if any)
echo Choose [93m1[0m to view output in command window.
echo Choose [93m2[0m to save output to a file.
set /p tasklist-output=[36mOutput to: [0m
echo.
if %tasklist-output%==2 goto OutputToFile

:OutputToCMD
REM | Run tasklist
tasklist /s %TargetPC%
goto end

:OutputToFile
echo Choose [93m1[0m to input a destination manually.
echo Choose [93m2[0m to select destination by graphical interface.

set /p destination=[36mSelection method: [0m
echo.
if %destination%==2 goto fchooser

:manual-destination
echo [91mWarning:[0m Do not include final backslash in file path.
echo [91mWarning:[0m System variables result in error. Use absolute file paths.
set /p Destination=[36mEnter destination path: [0m
tasklist /s %TargetPC% > "%destination%\%FileName%
echo.
echo Saved as [35m%FileName%[0m in [35m%destination%[0m
goto end

:fchooser
setlocal
set "psCommand="(new-object -COM 'Shell.Application')^
.BrowseForFolder(0,'Please choose a folder.',0,0).self.path""
for /f "usebackq delims=" %%I in (`powershell %psCommand%`) do set "folder=%%I"
setlocal enabledelayedexpansion
tasklist /s %TargetPC% > "!folder!\%FileName%"
echo Saved as [35m%FileName%[0m in [35m!folder![0m
endlocal
goto end

REM | Pause and wait for user to close window
:end
echo.
pause