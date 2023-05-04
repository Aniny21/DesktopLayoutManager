@echo off
@rem �f�X�N�g�b�v�̃��C�A�E�g��ۑ�/����

:::::::::::::::::::::::::::::::::::::::::::::::::
:: �������烁�C������                            ::
:::::::::::::::::::::::::::::::::::::::::::::::::

@rem �Ǘ��Ҍ����ŊJ���Ȃ���
openfiles > nul 2>&1 
if not %ERRORLEVEL%==0 (
  powershell start-process \"%~f0\" -verb runas > nul
  exit /b
)

:::::::::::::::::::::::::::::::::::::::::::::::::
:: ����������                                   ::
:::::::::::::::::::::::::::::::::::::::::::::::::

@rem �薼�ύX
title DesktopLayoutManager Version 3.5.1

@rem �N����ʂ�\�����邩
set showWelcomeScreen=1
@rem �G�N�X�v���[���[�̃A�X�L�[�A�[�g��\�����邩
set showExplorerAsciiArt=1
@rem �o�b�N�A�b�v��ۑ�����t�H���_��
set savedDirName=SavedDesktopLayout


if not %showWelcomeScreen%==0 (
    call :welcomeScreen
)

cd %~dp0

@rem tmp�t�@�C����
set tmpFilePath=%TMP%\DesktopLayoutManagerTmp
if not exist  %tmpFilePath% echo: >  %tmpFilePath%

:::::::::::::::::::::::::::::::::::::::::::::::::
:: �����������I��                               ::
:::::::::::::::::::::::::::::::::::::::::::::::::



setlocal enabledelayedexpansion
echo ���ڂ�I��œ��͂��Ă��������B
echo 1:�ۑ� 2:����
set /P num=""
if [%num%]==[] (
    cls
    echo �����ȓ��͂ł��B
    echo Enter�������ďI�����܂��B
    pause > nul
    exit /b 1
)

@rem �f�[�^�����ݎ����t���̃t�@�C���ɕۑ�
if %num%==1 (
    @rem �Ȃ���΃t�H���_���쐬���Ĉړ�
    If not exist %savedDirName% mkdir %savedDirName%
    cd %savedDirName%

    @rem ���ݎ������t�H�[�}�b�g
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
    echo �f�X�N�g�b�v�̃��C�A�E�g��ۑ����Ă��܂�...
    reg save HKCU\SOFTWARE\Microsoft\Windows\Shell\Bags DesktopLayout!date2!.reg
    echo Enter�������ďI�����܂��B
) else if %num%==2 (
    call :restore
) else (
    cls
    echo �����ȓ��͂ł��B
    echo Enter�������ďI�����܂��B
)
endlocal


:::::::::::::::::::::::::::::::::::::::::::::::::
:: �I������                                     ::
:::::::::::::::::::::::::::::::::::::::::::::::::

@rem tmp�t�@�C�����폜
del %tmpFilePath%

pause > nul
exit /b

:::::::::::::::::::::::::::::::::::::::::::::::::
:: �I�������I��                                 ::
:::::::::::::::::::::::::::::::::::::::::::::::::




:::::::::::::::::::::::::::::::::::::::::::::::::
:: ��������֐�                                 ::
:::::::::::::::::::::::::::::::::::::::::::::::::

@rem ������I��
@rem ���͂Ȃ����Ȃ�
:restore
@rem �o�b�N�A�b�v�t�H���_������΂�������I���A�Ȃ���Β��ړ��͂�����B

If exist %savedDirName% (
    cd %savedDirName%
    call :selectSavedFile
) else (
    call :inputFilePath
)
exit /b 0

::::::::::::::::::::::::::::::::::::::::::::::::::

@rem �ۑ�����Ă���t�@�C����I��
:selectSavedFile
call :showSavedFiles
set /P selectFile=""
if [%selectFile%]==[] (
    cls
    echo �����ȓ��͂ł��B
    echo Enter�������ďI�����܂��B
    exit /b 1
)

@rem ���͂��ꂽ�ԍ��̃f�[�^���i�[
for /f "usebackq delims=" %%i in (`findstr "." %tmpFilePath% ^| findstr "^%selectFile%:"`) do set result=%%i

if [%result%]==[] (
    cls
    echo ���͂�����������܂���B
    echo Enter�������ďI�����܂��B
    exit /b 1    
)
@rem �t�@�C���𓊂���
call :correctInput %result:~-31%
exit /b 0

::::::::::::::::::::::::::::::::::::::::::::::::::

@rem �ۑ�����Ă���t�@�C����\��
:showSavedFiles
cls
@rem �o�b�N�A�b�v�t�@�C���̃��X�g��tmp�t�@�C���ɕۑ�
dir /b /o-d | findstr "^.*DesktopLayout[0-9]*\.reg" | findstr /N "." > %tmpFilePath%

echo �ǂ̃t�@�C���𕜌����܂���? (�V������)
@rem ���X�g��ǂݍ���
@rem �������؂�o���ē��t�\��
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
echo %savedDirName%�t�H���_������܂���B
echo �o�b�N�A�b�v�t�@�C������͂��Ă��������B
set /P file=""
if [%file%]==[] (
    cls
    echo �����ȓ��͂ł��B
    echo Enter�������ďI�����܂��B
    exit /b 1
) else (
    call :correctInput %file%
)
exit /b 0

::::::::::::::::::::::::::::::::::::::::::::::::::

@rem �t�@�C�����݂邩�`�F�b�N
:correctInput 
if exist "%~1" (
    call :fileCheck "%~1"
) else (
    cls
    echo ���͂��ꂽ�t�@�C�������݂��܂���B
    echo Enter�������ďI�����܂��B
    exit /b 1
)
exit /b 0

::::::::::::::::::::::::::::::::::::::::::::::::::

@rem ���K�\���Ő������t�@�C�����`�F�b�N
:fileCheck
echo %~1 | findstr "^.*DesktopLayout[0-9]*\.reg" > nul
if %ERRORLEVEL%==0 (
    @rem �������t�@�C��
    call :allCorrect "%~1"
) else (
    cls
    echo ���͂��ꂽ�t�@�C��������������܂���B
    echo Enter�������ďI�����܂��B
    exit /b 1    
)
exit /b 0

::::::::::::::::::::::::::::::::::::::::::::::::::

@rem ���ׂẴt�@�C���`�F�b�N�����i
:allCorrect
cls

if not %showExplorerAsciiArt%==0 (
    call :explorerAsciiArt
)

echo �G�N�X�v���[���[�̍ċN�����K�v�ł��B 
echo ����ɂ��ړ�/�R�s�[���̃f�[�^�Ȃǂ�������\��������܂��B
echo �ċN�����܂���? [Y/n]
set yesOrNo=
set /P yesOrNo=""
if [%yesOrNo%]==[] (
    call :runRestore "%~1"
) else (
    call :checkYesOrNo "%~1"
)
exit /b 0

::::::::::::::::::::::::::::::::::::::::::::::::::

@rem NULL�ł͂Ȃ��ϐ�YesOrNo���`�F�b�N
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
    echo �������L�����Z������܂����B
    echo Enter�������ďI�����܂��B
    exit /b 1
)
exit /b 0

::::::::::::::::::::::::::::::::::::::::::::::::::

@rem ���������s
:runRestore
cls
echo �f�X�N�g�b�v�̃��C�A�E�g�𕜌����Ă��܂�...
taskkill /F /IM explorer.exe > nul
reg restore HKCU\SOFTWARE\Microsoft\Windows\Shell\Bags "%~1"
start explorer.exe > nul
echo Enter�������ďI�����܂��B
exit /b 0

::::::::::::::::::::::::::::::::::::::::::::::::::

@rem welcomeScreen
:welcomeScreen
cls
echo [1m
echo DesktopLayoutManager���N����...
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

@rem �J�[�\���̓_�ł𖳌�
set /P tmpVar=[?25l<nul

@rem �����ŉ�ʑ���
for /L %%z in (1,1,28) do (
    ping -n 1 localhost>nul
    echo:
)
@rem �J�[�\������ֈړ�
set /P tmpVar=[2;0f<nul
@rem �J�[�\���̓_�ł�L��
set /P tmpVar=[?25h<nul
exit /b

::::::::::::::::::::::::::::::::::::::::::::::::::

@rem Explorer�̃A�X�L�[�A�[�g
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