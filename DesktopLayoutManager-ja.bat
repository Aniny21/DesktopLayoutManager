@echo off
@rem デスクトップのレイアウトを保存/復元

:::::::::::::::::::::::::::::::::::::::::::::::::
:: ここからメイン処理                            ::
:::::::::::::::::::::::::::::::::::::::::::::::::

@rem 管理者権限で開きなおす
openfiles > nul 2>&1 
if not %ERRORLEVEL%==0 (
  powershell start-process \"%~f0\" -verb runas > nul
  exit /b
)

:::::::::::::::::::::::::::::::::::::::::::::::::
:: 初期化処理                                   ::
:::::::::::::::::::::::::::::::::::::::::::::::::

@rem 題名変更
title DesktopLayoutManager Version 1.0

@rem 起動画面を表示するか
set showWelcomeScreen=1
@rem エクスプローラーのアスキーアートを表示するか
set showExplorerAsciiArt=1
@rem バックアップを保存するフォルダ名
set savedDirName=SavedDesktopLayout


if not %showWelcomeScreen%==0 (
    call :welcomeScreen
)

cd %~dp0

@rem tmpファイル名
set tmpFilePath=%TMP%\DesktopLayoutManagerTmp
if not exist  %tmpFilePath% echo: >  %tmpFilePath%

:::::::::::::::::::::::::::::::::::::::::::::::::
:: 初期化処理終了                               ::
:::::::::::::::::::::::::::::::::::::::::::::::::



setlocal enabledelayedexpansion
echo 項目を選んで入力してください。
echo 1:保存 2:復元
set /P num=""
if [%num%]==[] (
    cls
    echo 無効な入力です。
    echo Enterを押して終了します。
    pause > nul
    exit /b 1
)

@rem データを現在時刻付きのファイルに保存
if %num%==1 (
    @rem なければフォルダを作成して移動
    If not exist %savedDirName% mkdir %savedDirName%
    cd %savedDirName%

    @rem 現在時刻をフォーマット
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
    echo デスクトップのレイアウトを保存しています...
    reg save HKCU\SOFTWARE\Microsoft\Windows\Shell\Bags DesktopLayout!date2!.reg
    echo Enterを押して終了します。
) else if %num%==2 (
    call :restore
) else (
    cls
    echo 無効な入力です。
    echo Enterを押して終了します。
)
endlocal


:::::::::::::::::::::::::::::::::::::::::::::::::
:: 終了処理                                     ::
:::::::::::::::::::::::::::::::::::::::::::::::::

@rem tmpファイルを削除
del %tmpFilePath%

pause > nul
exit /b

:::::::::::::::::::::::::::::::::::::::::::::::::
:: 終了処理終了                                 ::
:::::::::::::::::::::::::::::::::::::::::::::::::




:::::::::::::::::::::::::::::::::::::::::::::::::
:: ここから関数                                 ::
:::::::::::::::::::::::::::::::::::::::::::::::::

@rem 復元を選択
@rem 入力なしを省く
:restore
@rem バックアップフォルダがあればそこから選択、なければ直接入力させる。

If exist %savedDirName% (
    cd %savedDirName%
    call :selectSavedFile
) else (
    call :inputFilePath
)
exit /b 0

::::::::::::::::::::::::::::::::::::::::::::::::::

@rem 保存されているファイルを選択
:selectSavedFile
call :showSavedFiles
set /P selectFile=""
if [%selectFile%]==[] (
    cls
    echo 無効な入力です。
    echo Enterを押して終了します。
    exit /b 1
)

@rem 入力された番号のデータを格納
for /f "usebackq delims=" %%i in (`findstr "." %tmpFilePath% ^| findstr "^%selectFile%:"`) do set result=%%i

if [%result%]==[] (
    cls
    echo 入力が正しくありません。
    echo Enterを押して終了します。
    exit /b 1    
)
@rem ファイルを投げる
call :correctInput %result:~-31%
exit /b 0

::::::::::::::::::::::::::::::::::::::::::::::::::

@rem 保存されているファイルを表示
:showSavedFiles
cls
@rem バックアップファイルのリストをtmpファイルに保存
dir /b /o-d | findstr "^.*DesktopLayout[0-9]*\.reg" | findstr /N "." > %tmpFilePath%

echo どのファイルを復元しますか? (新しい順)
@rem リストを読み込み
@rem 文字列を切り出して日付表示
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
echo %savedDirName%フォルダがありません。
echo バックアップファイルを入力してください。
set /P file=""
if [%file%]==[] (
    cls
    echo 無効な入力です。
    echo Enterを押して終了します。
    exit /b 1
) else (
    call :correctInput %file%
)
exit /b 0

::::::::::::::::::::::::::::::::::::::::::::::::::

@rem ファイルが在るかチェック
:correctInput 
if exist "%~1" (
    call :fileCheck "%~1"
) else (
    cls
    echo 入力されたファイルが存在しません。
    echo Enterを押して終了します。
    exit /b 1
)
exit /b 0

::::::::::::::::::::::::::::::::::::::::::::::::::

@rem 正規表現で正しいファイルかチェック
:fileCheck
echo %~1 | findstr "^.*DesktopLayout[0-9]*\.reg" > nul
if %ERRORLEVEL%==0 (
    @rem 正しいファイル
    call :allCorrect "%~1"
) else (
    cls
    echo 入力されたファイルが正しくありません。
    echo Enterを押して終了します。
    exit /b 1    
)
exit /b 0

::::::::::::::::::::::::::::::::::::::::::::::::::

@rem すべてのファイルチェックを合格
:allCorrect
cls

if not %showExplorerAsciiArt%==0 (
    call :explorerAsciiArt
)

echo エクスプローラーの再起動が必要です。 
echo これにより移動/コピー中のデータなどが失われる可能性があります。
echo 再起動しますか? [Y/n]
set yesOrNo=
set /P yesOrNo=""
if [%yesOrNo%]==[] (
    call :runRestore "%~1"
) else (
    call :checkYesOrNo "%~1"
)
exit /b 0

::::::::::::::::::::::::::::::::::::::::::::::::::

@rem NULLではない変数YesOrNoをチェック
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
    echo 復元がキャンセルされました。
    echo Enterを押して終了します。
    exit /b 1
)
exit /b 0

::::::::::::::::::::::::::::::::::::::::::::::::::

@rem 復元を実行
:runRestore
cls
echo デスクトップのレイアウトを復元しています...
taskkill /F /IM explorer.exe > nul
reg restore HKCU\SOFTWARE\Microsoft\Windows\Shell\Bags "%~1"
start explorer.exe > nul
echo Enterを押して終了します。
exit /b 0

::::::::::::::::::::::::::::::::::::::::::::::::::

@rem welcomeScreen
:welcomeScreen
cls
echo [1m
echo DesktopLayoutManagerを起動中...
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

@rem カーソルの点滅を無効
set /P tmpVar=[?25l<nul

@rem 高速で画面送り
for /L %%z in (1,1,28) do (
    ping -n 1 localhost>nul
    echo:
)
@rem カーソルを上へ移動
set /P tmpVar=[2;0f<nul
@rem カーソルの点滅を有効
set /P tmpVar=[?25h<nul
exit /b

::::::::::::::::::::::::::::::::::::::::::::::::::

@rem Explorerのアスキーアート
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