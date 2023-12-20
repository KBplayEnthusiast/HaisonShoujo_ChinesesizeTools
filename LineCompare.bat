@echo off
setlocal enabledelayedexpansion

:: 获取两个目录
set /p dir1=Enter the path of the first directory: 
set /p dir2=Enter the path of the second directory: 

:: 检查目录
if not exist "%dir1%" (
    echo Directory "%dir1%" does not exist.
    goto :eof
)
if not exist "%dir2%" (
    echo Directory "%dir2%" does not exist.
    goto :eof
)

:: 比较文件
for %%F in ("%dir1%\*.txt") do (
    if exist "%dir2%\%%~nxF" (
        set /a count1=0
        set /a count2=0
        for /f %%N in ('find /c /v "" ^< "%%F"') do set /a count1=%%N
        for /f %%N in ('find /c /v "" ^< "%dir2%\%%~nxF"') do set /a count2=%%N
        if !count1! neq !count2! (
            echo %%~nxF - Different line counts: [First directory: !count1!] [Second directory: !count2!]
        ) else (
            echo %%~nxF - Same line counts: !count1! lines
        )
    )
)

echo Done.
endlocal