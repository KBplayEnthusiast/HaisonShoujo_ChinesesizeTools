@echo off
setlocal enabledelayedexpansion

REM 获取目录参数
set "DIRECTORY=%~1"

REM 检查是否提供了目录
if "%DIRECTORY%"=="" (
    echo Please provide a directory.
    exit /b
)

REM 检查目录是否存在
if not exist "%DIRECTORY%\*" (
    echo The directory does not exist.
    exit /b
)

REM 遍历目录下的所有.txt文件
for %%F in ("%DIRECTORY%\*.txt") do (
    echo Processing file: %%F
    cscript //Nologo "%~dp0CheckFileFormat.vbs" "%%F"
)

echo Done processing files.
pause
endlocal