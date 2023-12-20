@echo off
setlocal enabledelayedexpansion

:: 获取拖拽文件的完整路径
set "InputFile=%~1"

:: 确保文件存在
if not exist "%InputFile%" (
    echo Please drag a text file onto the script.
    exit /b
)

:: 脚本1
:: 创建一个临时中间文件名
set "TempFile=%~dpn1[1]%~x1"

:: 用于匹配开头为【##数字##|】的正则表达式
set "Pattern=##[0-9][0-9][0-9][0-9][0-9][0-9]##|"

:: 创建或清空临时输出文件
echo. 2>"%TempFile%"

:: 读取输入文件并处理每一行
for /f "usebackq delims=" %%a in (`type "%InputFile%" ^| findstr /R "%Pattern%"`) do (
    set "Line=%%a"
    set "Line=!Line:*|=!"
    echo !Line!>>"%TempFile%"
)

:: 创建最终输出文件名A
set "OutputFileA=[A]%~n1[1]%~x1"

:: 创建最终输出文件名B
set "OutputFileB=[B]%~n1[1]%~x1"

:: 设置行数计数器
set /a "count=0"

:: 通过脚本1的输出临时文件开始处理
echo Processing temporary file to add extra lines...

:: 读取临时文件，准备输出到两个文件
for /f "delims=" %%a in ('type "%TempFile%"') do (
    set /a "count+=1"
    :: 每30行添加空行到两个文件
    if !count! equ 30 (
        echo.>> "%OutputFileA%"
        echo.>> "%OutputFileB%"
        set /a "count=0"
    )
    :: 输出原始文本行到两个文件
    echo %%a>> "%OutputFileA%"
    echo %%a>> "%OutputFileB%"
)

:: 完成处理
echo Processing complete.

:: 删除中间文件
del "%TempFile%"

:: 返回最终文件路径
echo Final output files: "%OutputFileA%" and "%OutputFileB%"