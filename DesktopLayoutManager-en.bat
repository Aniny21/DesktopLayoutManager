@echo off
@rem Save or restore the layout of the desktop icons

:::::::::::::::::::::::::::::::::::::::::::::::::
:: Main processing from here                   ::
:::::::::::::::::::::::::::::::::::::::::::::::::

@rem Reopen with administrative privileges
openfiles > nul 2>&1 
if not %ERRORLEVEL%==0 (
  powershell start-process \"%~f0\" -verb runas > nul
  exit /b
)

:::::::::::::::::::::::::::::::::::::::::::::::::
:: [START] Initialization process              ::
:::::::::::::::::::::::::::::::::::::::::::::::::

@rem Window Title
title DesktopLayoutManager Version 1.0

@rem Whether to display the startup screen
set showWelcomeScreen=1
@rem Whether to display ASCII art in Explorer
set showExplorerAsciiArt=1
@rem Name of the folder where Desktop Layout is saved
set savedDirName=SavedDesktopLayout


if not %showWelcomeScreen%==0 (
    call :welcomeScreen
)

cd %~dp0

@rem temporary file path
set tmpFilePath=%TMP%\DesktopLayoutManagerTmp
if not exist  %tmpFilePath% echo: >  %tmpFilePath%

:::::::::::::::::::::::::::::::::::::::::::::::::
:: [END] Initialization process                ::
:::::::::::::::::::::::::::::::::::::::::::::::::



setlocal enabledelayedexpansion
echo Please select an item and enter it.
echo 1: Save 2: Restore
set /P num=""
if [%num%]==[] (
    cls
    echo Invalid input.
    echo Press Enter to exit.
    pause > nul
    exit /b 1
)

@rem Save data to a file with current time
if %num%==1 (
    @rem Create a folder if there is no folder
    If not exist %savedDirName% mkdir %savedDirName%
    cd %savedDirName%

    @rem Current date and time
    set year=%date:~0,4%
    set month=%date:~5,2%
    set day=%date:~8,2%
    set time2=%time::=%
    set time2=!time2:.=!
    set time2=!time2: =0!
    set time2=!time2:~-0,-2!
    set time2=!time2:~0!
    set date2=!year!!month!!day!!time2!
    cls
    echo Save desktop layouts...
    reg save HKCU\SOFTWARE\Microsoft\Windows\Shell\Bags DesktopLayout!date2!.reg
    echo Press Enter to exit.
) else if %num%==2 (
    call :restore
) else (
    cls
    echo Invalid input.
    echo Press Enter to exit.
)
endlocal


:::::::::::::::::::::::::::::::::::::::::::::::::
:: [START] Termination processes               ::
:::::::::::::::::::::::::::::::::::::::::::::::::

@rem Delete temporary file
del %tmpFilePath%

pause > nul
exit /b

:::::::::::::::::::::::::::::::::::::::::::::::::
:: [END] Termination processes                 ::
:::::::::::::::::::::::::::::::::::::::::::::::::




:::::::::::::::::::::::::::::::::::::::::::::::::
:: [START] Subroutines                         ::
:::::::::::::::::::::::::::::::::::::::::::::::::

:restore
@rem If there is a backup folder, select from it; if not, have the user enter it directly.

If exist %savedDirName% (
    cd %savedDirName%
    call :selectSavedFile
) else (
    call :inputFilePath
)
exit /b 0

::::::::::::::::::::::::::::::::::::::::::::::::::

@rem Select a saved file
:selectSavedFile
call :showSavedFiles
set /P selectFile=""
if [%selectFile%]==[] (
    cls
    echo Invalid input.
    echo Press Enter to exit.
    exit /b 1
)

@rem Stores data for the entered number
for /f "usebackq delims=" %%i in (`findstr "." %tmpFilePath% ^| findstr "^%selectFile%:"`) do set result=%%i

if [%result%]==[] (
    cls
    echo Invalid input.
    echo Press Enter to exit.
    exit /b 1    
)

call :correctInput %result:~-31%
exit /b 0

::::::::::::::::::::::::::::::::::::::::::::::::::

@rem Show saved files
:showSavedFiles
cls
@rem Save list of backup files to temporary file
dir /b /o-d | findstr "^.*DesktopLayout[0-9]*\.reg" | findstr /N "." > %tmpFilePath%

echo Select the files you wish to restore. (in order of newest to oldest)
@rem Load list
@rem Cut out string and display date
setlocal enabledelayedexpansion
for /f %%i in (%tmpFilePath%) do (
    set i=%%i
    echo %%i ^(!i:~-18,4!^/!i:~-14,2!^/!i:~-12,2! !i:~-10,2!^:!i:~-8,2!^:!i:~-6,2!^)
)
endlocal
exit /b 

::::::::::::::::::::::::::::::::::::::::::::::::::

:inputFilePath
cls
echo The %savedDirName% folder is missing.
echo Please enter the backup file.
set /P file=""
if [%file%]==[] (
    cls
    echo Invalid input.
    echo Press Enter to exit.
    exit /b 1
) else (
    call :correctInput %file%
)
exit /b 0

::::::::::::::::::::::::::::::::::::::::::::::::::

@rem Check if the file exists
:correctInput 
if exist "%~1" (
    call :fileCheck "%~1"
) else (
    cls
    echo The entered file does not exist.
    echo Press Enter to exit.
    exit /b 1
)
exit /b 0

::::::::::::::::::::::::::::::::::::::::::::::::::

@rem Check for correct file
:fileCheck
echo %~1 | findstr "^.*DesktopLayout[0-9]*\.reg" > nul
if %ERRORLEVEL%==0 (
    call :allCorrect "%~1"
) else (
    cls
    echo The entered file is incorrect.
    echo Press Enter to exit.
    exit /b 1    
)
exit /b 0

::::::::::::::::::::::::::::::::::::::::::::::::::

@rem Passed all file checks
:allCorrect
cls

if not %showExplorerAsciiArt%==0 (
    call :explorerAsciiArt
)

echo Explorer needs to be restarted.
echo This may result in loss of data, etc. during the move/copy.
echo Do you want to continue? [Y/n]
set yesOrNo=
set /P yesOrNo=""
if [%yesOrNo%]==[] (
    call :runRestore "%~1"
) else (
    call :checkYesOrNo "%~1"
)
exit /b 0

::::::::::::::::::::::::::::::::::::::::::::::::::

@rem Check non-null variable YesOrNo
:checkYesOrNo
if %yesOrNo:y=y%==y (
    set isYes=1
) else if %yesOrNo:yes=y%==y (
    set isYes=1
) else if %yesOrNo:n=n%==n (
    set isYes=0
) else if %yesOrNo:no=n%==n (
    set isYes=0
) else (
    goto :allCorrect "%~1"
)
if %isYes%==1 (
    call :runRestore "%~1"
) else (
    cls
    echo Restore has been canceled.
    echo Press Enter to exit.
    exit /b 1
)
exit /b 0

::::::::::::::::::::::::::::::::::::::::::::::::::

@rem Run restore
:runRestore
cls
echo Restoring desktop layout...
taskkill /F /IM explorer.exe > nul
reg restore HKCU\SOFTWARE\Microsoft\Windows\Shell\Bags "%~1"
start explorer.exe > nul
echo Press Enter to exit.
exit /b 0

::::::::::::::::::::::::::::::::::::::::::::::::::

:welcomeScreen
cls
echo [1m
echo DesktopLayoutManager is running...
echo:
echo  -+********************************************+- 
echo %%%%:............................................:%%%%
echo @+ #@########################################%%%% =@
echo @+ ##                                        *%% =@
echo @+ ##                                        *%% =@
echo @+ ## [31m ooooooooo  [33mooooo       [32moooo     oooo [0m[1m *%% =@
echo @+ ## [31m  888    88o[33m 888        [32m 8888o   888  [0m[1m *%% =@
echo @+ ## [31m  888    888[33m 888        [32m 88 888o8 88  [0m[1m *%% =@
echo @+ ## [31m  888    888[33m 888      o [32m 88  888  88  [0m[1m *%% =@
echo @+ ## [31m o888ooo88  [33mo888ooooo88 [32mo88o  8  o88o [0m[1m *%% =@
echo @+ ## [31m      esktop[33m      ayout [32m        anager[0m[1m *%% =@
echo @+ ##                                        *%% =@
echo @+ ##                                        *%% =@
echo @+ #%%----------------------------------------*%% =@
echo @+ -==========================================- =@
echo @+                     :##:                     =@
echo @*                     .##:                     +@
echo +@+============================================+@+
echo   :-------------------@*--+@=------------------: 
echo                      .@+  =@:                     
echo                :******************:                
echo [0m
echo:

@rem Disable cursor blinking
set /P tmpVar=[?25l<nul

@rem Screen feed
for /L %%z in (1,1,28) do (
    ping -n 1 localhost>nul
    echo:
)
@rem Move cursor up
set /P tmpVar=[2;0f<nul
@rem Enable blinking cursor
set /P tmpVar=[?25h<nul
exit /b

::::::::::::::::::::::::::::::::::::::::::::::::::

:explorerAsciiArt
echo   [1m
echo   [33m -+++++++++++++++=:                            
echo   [33m*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%#-                          
echo   [33m#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%#-::::::::::::::::::::.    
echo   [33m#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%#=::::::::::::::::::::::::   
echo   [93m:-----------------::::::::::::::::::::::::::   
echo   [93m::::::::::::::::::::::::::::::::::::::::::::   
echo   [93m::::::::::::::::::::::::::::::::::::::::::::   
echo   [93m::::::::::::::::::::::::::::::::::::::::::::   
echo   [93m:::::::::--=======================-:::::::::   
echo   [93m:::::::[36m-+##########################*-[93m:::::::   
echo   [93m:::::::[36m+############################+[93m:::::::   
echo   [93m:::::::[36m+############################*[93m:::::::   
echo   [93m:::::::[36m+######*[93m==============[36m*######*-[93m::::::   
echo   [93m::::::[36m-+######*[93m-::::::::::::-[36m+######*-[93m::::::   
echo   [93m::::::[36m-*######*[93m-::::::::::::-[36m*######*-[93m::::::   
echo   [93m .::::[36m-*######*[93m-::::::::::::-[36m*######*-[93m::::.    
echo   [93m       :======-              :======-     
echo   [0m

exit /b

::::::::::::::::::::::::::::::::::::::::::::::::::

:colorEcho
echo [36m%~1%[0m
exit /b

::::::::::::::::::::::::::::::::::::::::::::::::::