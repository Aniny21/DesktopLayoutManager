@echo off
@rem ÉfÉXÉNÉgÉbÉvÇÃÉåÉCÉAÉEÉgÇï€ë∂/ïúå≥

:::::::::::::::::::::::::::::::::::::::::::::::::
:: Ç±Ç±Ç©ÇÁÉÅÉCÉìèàóù                            ::
:::::::::::::::::::::::::::::::::::::::::::::::::

@rem ä«óùé“å†å¿Ç≈äJÇ´Ç»Ç®Ç∑
openfiles > nul 2>&1 
if not %ERRORLEVEL%==0 (
  powershell start-process \"%~f0\" -verb runas > nul
  exit /b
)

:::::::::::::::::::::::::::::::::::::::::::::::::
:: èâä˙âªèàóù                                   ::
:::::::::::::::::::::::::::::::::::::::::::::::::

@rem ëËñºïœçX
title DesktopLayoutManager Version 3.5.1

@rem ãNìÆâÊñ Çï\é¶Ç∑ÇÈÇ©
set showWelcomeScreen=1
@rem ÉGÉNÉXÉvÉçÅ[ÉâÅ[ÇÃÉAÉXÉLÅ[ÉAÅ[ÉgÇï\é¶Ç∑ÇÈÇ©
set showExplorerAsciiArt=1
@rem ÉoÉbÉNÉAÉbÉvÇï€ë∂Ç∑ÇÈÉtÉHÉãÉ_ñº
set savedDirName=SavedDesktopLayout


if not %showWelcomeScreen%==0 (
    call :welcomeScreen
)

cd %~dp0

@rem tmpÉtÉ@ÉCÉãñº
set tmpFilePath=%TMP%\DesktopLayoutManagerTmp
if not exist  %tmpFilePath% echo: >  %tmpFilePath%

:::::::::::::::::::::::::::::::::::::::::::::::::
:: èâä˙âªèàóùèIóπ                               ::
:::::::::::::::::::::::::::::::::::::::::::::::::



setlocal enabledelayedexpansion
echo çÄñ⁄ÇëIÇÒÇ≈ì¸óÕÇµÇƒÇ≠ÇæÇ≥Ç¢ÅB
echo 1:ï€ë∂ 2:ïúå≥
set /P num=""
if [%num%]==[] (
    cls
    echo ñ≥å¯Ç»ì¸óÕÇ≈Ç∑ÅB
    echo EnterÇâüÇµÇƒèIóπÇµÇ‹Ç∑ÅB
    pause > nul
    exit /b 1
)

@rem ÉfÅ[É^Çåªç›éûçèïtÇ´ÇÃÉtÉ@ÉCÉãÇ…ï€ë∂
if %num%==1 (
    @rem Ç»ÇØÇÍÇŒÉtÉHÉãÉ_ÇçÏê¨ÇµÇƒà⁄ìÆ
    If not exist %savedDirName% mkdir %savedDirName%
    cd %savedDirName%

    @rem åªç›éûçèÇÉtÉHÅ[É}ÉbÉg
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
    echo ÉfÉXÉNÉgÉbÉvÇÃÉåÉCÉAÉEÉgÇï€ë∂ÇµÇƒÇ¢Ç‹Ç∑...
    reg save HKCU\SOFTWARE\Microsoft\Windows\Shell\Bags DesktopLayout!date2!.reg
    echo EnterÇâüÇµÇƒèIóπÇµÇ‹Ç∑ÅB
) else if %num%==2 (
    call :restore
) else (
    cls
    echo ñ≥å¯Ç»ì¸óÕÇ≈Ç∑ÅB
    echo EnterÇâüÇµÇƒèIóπÇµÇ‹Ç∑ÅB
)
endlocal


:::::::::::::::::::::::::::::::::::::::::::::::::
:: èIóπèàóù                                     ::
:::::::::::::::::::::::::::::::::::::::::::::::::

@rem tmpÉtÉ@ÉCÉãÇçÌèú
del %tmpFilePath%

pause > nul
exit /b

:::::::::::::::::::::::::::::::::::::::::::::::::
:: èIóπèàóùèIóπ                                 ::
:::::::::::::::::::::::::::::::::::::::::::::::::




:::::::::::::::::::::::::::::::::::::::::::::::::
:: Ç±Ç±Ç©ÇÁä÷êî                                 ::
:::::::::::::::::::::::::::::::::::::::::::::::::

@rem ïúå≥ÇëIë
@rem ì¸óÕÇ»ÇµÇè»Ç≠
:restore
@rem ÉoÉbÉNÉAÉbÉvÉtÉHÉãÉ_Ç™Ç†ÇÍÇŒÇªÇ±Ç©ÇÁëIëÅAÇ»ÇØÇÍÇŒíºê⁄ì¸óÕÇ≥ÇπÇÈÅB

If exist %savedDirName% (
    cd %savedDirName%
    call :selectSavedFile
) else (
    call :inputFilePath
)
exit /b 0

::::::::::::::::::::::::::::::::::::::::::::::::::

@rem ï€ë∂Ç≥ÇÍÇƒÇ¢ÇÈÉtÉ@ÉCÉãÇëIë
:selectSavedFile
call :showSavedFiles
set /P selectFile=""
if [%selectFile%]==[] (
    cls
    echo ñ≥å¯Ç»ì¸óÕÇ≈Ç∑ÅB
    echo EnterÇâüÇµÇƒèIóπÇµÇ‹Ç∑ÅB
    exit /b 1
)

@rem ì¸óÕÇ≥ÇÍÇΩî‘çÜÇÃÉfÅ[É^Çäiî[
for /f "usebackq delims=" %%i in (`findstr "." %tmpFilePath% ^| findstr "^%selectFile%:"`) do set result=%%i

if [%result%]==[] (
    cls
    echo ì¸óÕÇ™ê≥ÇµÇ≠Ç†ÇËÇ‹ÇπÇÒÅB
    echo EnterÇâüÇµÇƒèIóπÇµÇ‹Ç∑ÅB
    exit /b 1    
)
@rem ÉtÉ@ÉCÉãÇìäÇ∞ÇÈ
call :correctInput %result:~-31%
exit /b 0

::::::::::::::::::::::::::::::::::::::::::::::::::

@rem ï€ë∂Ç≥ÇÍÇƒÇ¢ÇÈÉtÉ@ÉCÉãÇï\é¶
:showSavedFiles
cls
@rem ÉoÉbÉNÉAÉbÉvÉtÉ@ÉCÉãÇÃÉäÉXÉgÇtmpÉtÉ@ÉCÉãÇ…ï€ë∂
dir /b /o-d | findstr "^.*DesktopLayout[0-9]*\.reg" | findstr /N "." > %tmpFilePath%

echo Ç«ÇÃÉtÉ@ÉCÉãÇïúå≥ÇµÇ‹Ç∑Ç©? (êVÇµÇ¢èá)
@rem ÉäÉXÉgÇì«Ç›çûÇ›
@rem ï∂éöóÒÇêÿÇËèoÇµÇƒì˙ïtï\é¶
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
echo %savedDirName%ÉtÉHÉãÉ_Ç™Ç†ÇËÇ‹ÇπÇÒÅB
echo ÉoÉbÉNÉAÉbÉvÉtÉ@ÉCÉãÇì¸óÕÇµÇƒÇ≠ÇæÇ≥Ç¢ÅB
set /P file=""
if [%file%]==[] (
    cls
    echo ñ≥å¯Ç»ì¸óÕÇ≈Ç∑ÅB
    echo EnterÇâüÇµÇƒèIóπÇµÇ‹Ç∑ÅB
    exit /b 1
) else (
    call :correctInput %file%
)
exit /b 0

::::::::::::::::::::::::::::::::::::::::::::::::::

@rem ÉtÉ@ÉCÉãÇ™ç›ÇÈÇ©É`ÉFÉbÉN
:correctInput 
if exist "%~1" (
    call :fileCheck "%~1"
) else (
    cls
    echo ì¸óÕÇ≥ÇÍÇΩÉtÉ@ÉCÉãÇ™ë∂ç›ÇµÇ‹ÇπÇÒÅB
    echo EnterÇâüÇµÇƒèIóπÇµÇ‹Ç∑ÅB
    exit /b 1
)
exit /b 0

::::::::::::::::::::::::::::::::::::::::::::::::::

@rem ê≥ãKï\åªÇ≈ê≥ÇµÇ¢ÉtÉ@ÉCÉãÇ©É`ÉFÉbÉN
:fileCheck
echo %~1 | findstr "^.*DesktopLayout[0-9]*\.reg" > nul
if %ERRORLEVEL%==0 (
    @rem ê≥ÇµÇ¢ÉtÉ@ÉCÉã
    call :allCorrect "%~1"
) else (
    cls
    echo ì¸óÕÇ≥ÇÍÇΩÉtÉ@ÉCÉãÇ™ê≥ÇµÇ≠Ç†ÇËÇ‹ÇπÇÒÅB
    echo EnterÇâüÇµÇƒèIóπÇµÇ‹Ç∑ÅB
    exit /b 1    
)
exit /b 0

::::::::::::::::::::::::::::::::::::::::::::::::::

@rem Ç∑Ç◊ÇƒÇÃÉtÉ@ÉCÉãÉ`ÉFÉbÉNÇçáäi
:allCorrect
cls

if not %showExplorerAsciiArt%==0 (
    call :explorerAsciiArt
)

echo ÉGÉNÉXÉvÉçÅ[ÉâÅ[ÇÃçƒãNìÆÇ™ïKóvÇ≈Ç∑ÅB 
echo Ç±ÇÍÇ…ÇÊÇËà⁄ìÆ/ÉRÉsÅ[íÜÇÃÉfÅ[É^Ç»Ç«Ç™é∏ÇÌÇÍÇÈâ¬î\ê´Ç™Ç†ÇËÇ‹Ç∑ÅB
echo çƒãNìÆÇµÇ‹Ç∑Ç©? [Y/n]
set yesOrNo=
set /P yesOrNo=""
if [%yesOrNo%]==[] (
    call :runRestore "%~1"
) else (
    call :checkYesOrNo "%~1"
)
exit /b 0

::::::::::::::::::::::::::::::::::::::::::::::::::

@rem NULLÇ≈ÇÕÇ»Ç¢ïœêîYesOrNoÇÉ`ÉFÉbÉN
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
    echo ïúå≥Ç™ÉLÉÉÉìÉZÉãÇ≥ÇÍÇ‹ÇµÇΩÅB
    echo EnterÇâüÇµÇƒèIóπÇµÇ‹Ç∑ÅB
    exit /b 1
)
exit /b 0

::::::::::::::::::::::::::::::::::::::::::::::::::

@rem ïúå≥Çé¿çs
:runRestore
cls
echo ÉfÉXÉNÉgÉbÉvÇÃÉåÉCÉAÉEÉgÇïúå≥ÇµÇƒÇ¢Ç‹Ç∑...
taskkill /F /IM explorer.exe > nul
reg restore HKCU\SOFTWARE\Microsoft\Windows\Shell\Bags "%~1"
start explorer.exe > nul
echo EnterÇâüÇµÇƒèIóπÇµÇ‹Ç∑ÅB
exit /b 0

::::::::::::::::::::::::::::::::::::::::::::::::::

@rem welcomeScreen
:welcomeScreen
cls
echo [1m
echo DesktopLayoutManagerÇãNìÆíÜ...
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

@rem ÉJÅ[É\ÉãÇÃì_ñ≈Çñ≥å¯
set /P tmpVar=[?25l<nul

@rem çÇë¨Ç≈âÊñ ëóÇË
for /L %%z in (1,1,28) do (
    ping -n 1 localhost>nul
    echo:
)
@rem ÉJÅ[É\ÉãÇè„Ç÷à⁄ìÆ
set /P tmpVar=[2;0f<nul
@rem ÉJÅ[É\ÉãÇÃì_ñ≈ÇóLå¯
set /P tmpVar=[?25h<nul
exit /b

::::::::::::::::::::::::::::::::::::::::::::::::::

@rem ExplorerÇÃÉAÉXÉLÅ[ÉAÅ[Ég
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