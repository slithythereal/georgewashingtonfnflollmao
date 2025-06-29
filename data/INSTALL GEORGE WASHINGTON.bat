@echo off
color 0A
echo [ [ [ [ VS GEORGE WASHINGTON INSTALLER ] ] ] ]
echo INSTALLER SCRIPT BY @hifish__ ON TWITTER, EDITED BY @slithythereal for Vs George Washington

:: Check if user has Codename Engine.

:SCRIPTSTART

CHOICE /M "Do you have Codename Engine"

IF %ERRORLEVEL% == 1 GOTO GW
IF %ERRORLEVEL% == 2 GOTO CODENAME

:CODENAME

echo Downloading Codename Engine...
powershell -Command "$ProgressPreference = 'SilentlyContinue'; wget "https://nightly.link/FNF-CNE-Devs/CodenameEngine/workflows/windows/main/Codename%%20Engine.zip" -OutFile cne.zip"

if not exist "%cd%\Codename Engine" mkdir "%cd%\Codename Engine"

tar -xf cne.zip -C "%cd%\Codename Engine"

del "%cd%\cne.zip" 

ECHO Codename Engine successfully downloaded.

GOTO CNEFRESH

:GW

echo Please navigate to your Codename Engine mods folder.

set "psCommand="(new-object -COM 'Shell.Application')^
.BrowseForFolder(0,'Select where your mods folder is located.',0,0).self.path""

for /f "usebackq delims=" %%I in (`powershell %psCommand%`) do set "folder=%%I"

setlocal enabledelayedexpansion

if "!folder!" == "" GOTO SCRIPTSTART

echo Downloading vs George Washington to !folder!...
if exist "%cd%\link.txt" del "%cd%\link.txt"

powershell -Command "$ProgressPreference = 'SilentlyContinue'; wget "https://raw.githubusercontent.com/slithythereal/georgewashingtonfnflollmao/main/downloadLink.txt" -OutFile link.txt"
set /p mytextfile=< "%cd%\link.txt"

powershell -Command "$ProgressPreference = 'SilentlyContinue'; wget "%mytextfile%" -OutFile george.zip"

if not exist "!folder!\george-washington" mkdir "!folder!\george-washington"

tar -xf george.zip -C "!folder!\george-washington"

%SystemRoot%\explorer.exe "!folder!"

del "%cd%\george.zip" 
del "%cd%\link.txt"

GOTO END

:CNEFRESH

:: Automatically install George for them, since CNE is already located where the batch script runs.

if exist "%cd%\link.txt" del "%cd%\link.txt"

powershell -Command "$ProgressPreference = 'SilentlyContinue'; wget "https://raw.githubusercontent.com/slithythereal/georgewashingtonfnflollmao/main/downloadLink.txt" -OutFile link.txt"
set /p mytextfile=< "%cd%\link.txt"

powershell -Command "$ProgressPreference = 'SilentlyContinue'; wget "%mytextfile%" -OutFile george.zip"

if not exist "%cd%\Codename Engine\mods\george-washington" mkdir "%cd%\Codename Engine\mods\george-washington"  

tar -xf george.zip -C "%cd%\Codename Engine\mods\george-washington"

%SystemRoot%\explorer.exe "%cd%\Codename Engine"

del "%cd%\george.zip" 
del "%cd%\link.txt"

:END

echo VS George Washington successfully installed.
echo Open the game
echo then press [TAB] on the main menu to play vs George Washington.

pause