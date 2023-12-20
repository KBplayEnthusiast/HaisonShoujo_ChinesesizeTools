@echo off
setlocal enabledelayedexpansion

:: 获取文件路径
set "InputFile=%~1"
set "OutputFileTemp1=%~dpn1[2]%~x1"
set "OutputFileTemp2=%~dpn1[1]%~x1"
set "FinalOutputFile=%~dpn1[3]%~x1"

:: 确认文件是否存在
if not exist "%InputFile%" (
    echo Input file not found.
    exit /b
)

:: 文件处理循环 - 脚本1
:: 创建新文件
for /f "tokens=*" %%a in (%InputFile%) do (
    echo %%a >> "%OutputFileTemp1%"
)
echo Step 1 Done

:: 文件处理循环 - 脚本2
:: 创建输出文件
:: 设置初始nums值为1
set /a "Nums=1"
for /f "tokens=* delims=" %%i in (%OutputFileTemp1%) do (
    set "PaddedNum=00000!Nums!"
    set "PaddedNum=!PaddedNum:~-6!"
    set "OddPrefix=##!PaddedNum!##|"
    set "EvenPrefix=%%%%!PaddedNum!%%%%|"
    echo !OddPrefix!%%i >> "%OutputFileTemp2%"
    echo !EvenPrefix!%%i >> "%OutputFileTemp2%"
    if !Nums! LSS 99999 (
        set /a "Nums+=1"
    ) else (
        echo Maximum limit of processed lines reached.
        goto EndBatch2
    )
)
:EndBatch2
echo Step 2 Done

:: 文件处理循环 - 脚本3
:: 创建最终输出文件
if exist "%FinalOutputFile%" del "%FinalOutputFile%"
:: 初始化变量
set /a "LineNo=0"
set "LastLineEmpty=0"
for /f "delims=" %%i in (%OutputFileTemp2%) do (
    set /a "LineNo+=1"
    set /a "Odd=LineNo %% 2"
    if !Odd! equ 1 (
        echo %%i >> "%FinalOutputFile%"
    ) else (
        echo %%i >> "%FinalOutputFile%"
        echo(>> "%FinalOutputFile%"
    )
)
echo Step 3 Done

:: 清理临时文件
del "%OutputFileTemp1%"
del "%OutputFileTemp2%"
echo Final processing of "%InputFile%" is complete. Output file is "%FinalOutputFile%"

endlocal