@echo off
goto MODERN_INSTALL
set LIB_ID=LTspiceControlLibrary
set LIB_NAME=LTspice Control Library

set LTSPICE_REG_ID=LTspice IV
set LTSPICE_NAME=LTspice IV

echo.
echo ================================================================================
echo   %LIB_NAME%
echo ================================================================================
echo.
echo   1. Install (copy the library to the library directory of %LTSPICE_NAME%)
echo   2. Uninstall (remove the library from the library directory of %LTSPICE_NAME%)
echo.
echo   0. Quit
echo.
echo NOTE:
echo   Need to install %LTSPICE_NAME% before runnig this script.
echo   Need to run this script as administrator.
echo.
if "%1"=="" (
  set /p ODER_NO="Enter number (0-2):"
) else (
  echo Enter number (0-2^):%1
  set ODER_NO=%1
)
echo.
if "%ODER_NO%"=="1" goto GET_LTSPICE_DIR
if "%ODER_NO%"=="2" goto GET_LTSPICE_DIR
goto END

:GET_LTSPICE_DIR
set KEY="HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\%LTSPICE_REG_ID%"
set VALUE="UninstallString"

reg query %KEY% /v %VALUE% >nul 2>nul
if ERRORLEVEL 1 set KEY="HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\%LTSPICE_REG_ID%"

for /F "TOKENS=1,2,*" %%I IN ('reg query %KEY% /v %VALUE%') do if "%%I"==%VALUE% set DATA=%%K
set LTSPICE_DIR=%DATA:~0,-20%
if not exist "%LTSPICE_DIR%" (
  echo Could not find %LTSPICE_NAME% install directory.
  goto END
)

set SUB=lib\sub\%LIB_ID%
set SYM=lib\sym\%LIB_ID%

:UNINSTALL
if exist "%LTSPICE_DIR%%SUB%" (rmdir /S /Q "%LTSPICE_DIR%%SUB%" && echo remove "%LTSPICE_DIR%%SUB%".)
if exist "%LTSPICE_DIR%%SYM%" (rmdir /S /Q "%LTSPICE_DIR%%SYM%" && echo remove "%LTSPICE_DIR%%SYM%".)
if "%ODER_NO%"=="1" goto INSTALL
goto END

:INSTALL
xcopy "%~dp0%SUB%" "%LTSPICE_DIR%%SUB%\" /S /E /Y /R >nul && echo copy "%~dp0%SUB%" to "%LTSPICE_DIR%%SUB%".
xcopy "%~dp0%SYM%" "%LTSPICE_DIR%%SYM%\" /S /E /Y /R >nul && echo copy "%~dp0%SYM%" to "%LTSPICE_DIR%%SYM%".
goto END

goto OLD_END

:MODERN_INSTALL
setlocal

set LIB_ID=LTspiceControlLibrary
set LIB_NAME=LTspice Control Library

echo.
echo ================================================================================
echo   %LIB_NAME%
echo ================================================================================
echo.
echo   1. Install (copy the library to the LTspice directory)
echo   2. Uninstall (remove the library from the LTspice directory)
echo.
echo   0. Quit
echo.
echo NOTE:
echo   Install LTspice before running this script.
echo   No administrator rights required.
echo.

:: Handle input
if "%1"=="" (
  set /p ORDER_NO="Enter number (0-2): "
) else (
  echo Enter number (0-2^): %1
  set ORDER_NO=%1
)

echo.
if "%ORDER_NO%"=="1" goto MODERN_GET_DOCS
if "%ORDER_NO%"=="2" goto MODERN_GET_DOCS
goto OLD_END

:MODERN_GET_DOCS
set DATA=

:: === Method 1: PowerShell (preferred, works for OneDrive + company folders) ===
for /f "delims=" %%i in ('powershell -NoProfile -Command "[Environment]::GetFolderPath(''MyDocuments'')" 2^>nul') do set DATA=%%i

:: === Method 2: Registry fallback ===
if not defined DATA (
  for /f "tokens=2,*" %%A in ('reg query "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /v Personal 2^>nul') do (
    set DATA=%%B
  )
)

:: Expand variables like %USERPROFILE%
if defined DATA (
  call set DATA=%DATA%
)

:: === Method 3: Default fallback ===
if not defined DATA (
  set DATA=%USERPROFILE%\Documents
)

:: Final validation
if not exist "%DATA%" (
  echo Could not locate Documents folder.
  echo Tried PowerShell, Registry, and default path.
  goto OLD_END
)

echo Detected Documents folder:
echo   %DATA%
echo.

goto MODERN_CHECK_LTSPICE

:MODERN_CHECK_LTSPICE
:: Use specified LTspice directory with automatic username detection
set LTSPICE_DIR=C:\Users\%USERNAME%\AppData\Local\LTspice\

if not exist "%LTSPICE_DIR%" (
  echo Could not find LTspice directory at %LTSPICE_DIR%
  goto OLD_END
)

:MODERN_FOUND
set SUB=lib\sub\%LIB_ID%
set SYM=lib\sym\%LIB_ID%

:: Always uninstall first (safe overwrite)
if exist "%LTSPICE_DIR%%SUB%" (
  rmdir /S /Q "%LTSPICE_DIR%%SUB%"
  echo Removed "%LTSPICE_DIR%%SUB%"
)

if exist "%LTSPICE_DIR%%SYM%" (
  rmdir /S /Q "%LTSPICE_DIR%%SYM%"
  echo Removed "%LTSPICE_DIR%%SYM%"
)

if exist "%LTSPICE_DIR%examples" (
  rmdir /S /Q "%LTSPICE_DIR%examples"
  echo Removed "%LTSPICE_DIR%examples"
)

if "%ORDER_NO%"=="1" goto MODERN_INSTALL

goto OLD_END

:MODERN_INSTALL
xcopy "%~dp0%SUB%" "%LTSPICE_DIR%%SUB%\" /S /E /Y /R /I >nul
if %ERRORLEVEL%==0 (
  echo Copied "%SUB%" to "%LTSPICE_DIR%%SUB%"
) else (
  echo Failed to copy "%SUB%"
)

xcopy "%~dp0%SYM%" "%LTSPICE_DIR%%SYM%\" /S /E /Y /R /I >nul
if %ERRORLEVEL%==0 (
  echo Copied "%SYM%" to "%LTSPICE_DIR%%SYM%"
) else (
  echo Failed to copy "%SYM%"
)

echo.
echo ================================================================================
echo   Do you want to copy example files to the default folder?
echo ================================================================================
echo.
echo   1. Yes, copy examples
echo   2. No, skip examples
echo.
set /p EXAMPLES_CHOICE="Enter choice (1-2): "

if "%EXAMPLES_CHOICE%"=="1" (
  xcopy "%~dp0examples" "%LTSPICE_DIR%examples\" /S /E /Y /R /I >nul
  if %ERRORLEVEL%==0 (
    echo Copied "examples" to "%LTSPICE_DIR%examples"
  ) else (
    echo Failed to copy "examples"
  )
) else (
  echo Skipping examples copy.
)

echo.
echo ================================================================================
echo   THANK YOU FOR INSTALLING LTSPICE CONTROL LIBRARY!
echo ================================================================================
echo.
echo   The library has been successfully installed.
echo   You can now use the control components in your LTspice simulations.
echo.
echo   For more information, visit the project repository.
echo ================================================================================

goto OLD_END

:OLD_END
echo.
if "%1%"=="" pause
