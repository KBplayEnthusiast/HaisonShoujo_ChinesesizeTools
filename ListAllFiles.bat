@echo off
SetLocal EnableDelayedExpansion

:: 设置根目录(文件夹A)的路径；你需要在运行脚本时将"path\to\folderA"替换为相应的路径
set "rootDir=%~1"
set "outputFile=%rootDir%\filelist.txt"

:: 创建或覆盖已存在的输出文件
echo.> %outputFile%

:: 递归函数获取所有文件的相对路径
call :treeProcess "%rootDir%" ""

::完成
echo File list has been saved to %outputFile%
goto :eof

:treeProcess
for /f "tokens=*" %%f in ('dir /b /a-d "%~1\*.*"') do (
    echo %~2%%f>> %outputFile%
)
for /d %%d in ("%~1\*") do (
    set "subDir=%%d"
    set "subPath=%~2%%~nxd\"
    call :treeProcess "%%d" "!subPath!"
)
goto :eof