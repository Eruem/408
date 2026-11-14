@echo off
setlocal
set "VSCMD_SKIP_SENDTELEMETRY=1"
call "C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\Tools\VsDevCmd.bat" -arch=amd64 -host_arch=amd64 -no_logo >nul 2>nul
if errorlevel 1 (
  echo [error] cannot init VS environment
  exit /b 1
)

set "SRC=%~1"
if "%SRC%"=="" (
  echo [error] usage: run-c.cmd file.c
  exit /b 1
)
if not exist "%SRC%" (
  echo [error] file not found: %SRC%
  exit /b 1
)

set "DIR=%~dp1"
set "NAME=%~n1"
cd /d "%DIR%" || exit /b 1

if not exist ".cbuild" mkdir ".cbuild"
cl.exe /nologo /EHsc /Fe:".cbuild\%NAME%.exe" /Fo".cbuild\\" "%SRC%"
if errorlevel 1 exit /b 1

del /q ".cbuild\*.obj" 2>nul
echo.
".cbuild\%NAME%.exe"
exit /b %ERRORLEVEL%
