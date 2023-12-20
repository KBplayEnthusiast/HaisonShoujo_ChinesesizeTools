chcp 65001
@echo off
setlocal enabledelayedexpansion

:: 检查是否有文件被拖曳至脚本
if "%~1" == "" (
    echo 未检测到文本文件。
    pause
    exit /b
)

:: 确认文件是.txt格式
set "InputFile=%~1"
set "OutputFile=%~n1[N]%~x1"

:: 确认输入文件存在
if not exist "%InputFile%" (
    echo 文件 %InputFile% 不存在。
    pause
    exit /b
)

:: 替换文本内容并输出到新文件
(for /f "tokens=*" %%a in ('type "%InputFile%"') do (
    set "line=%%a"
    set "line=!line:“=「!"
    set "line=!line:”=」!"
    set "line=!line:他=她!"
    set "line=!line:'r'=＜r＞!"
    set "line=!line:‘r’=＜r＞!"
    set "line=!line:先生=前辈!"
    echo !line!
)) > "%OutputFile%"

echo 已创建文件：%OutputFile%
pause