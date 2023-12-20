' CheckFileFormat.vbs

Option Explicit

Dim objFSO, objFile, strPath, strLine
Dim i, n, blnExpectedEmpty
Dim intErrorCount

' 检查是否有文件参数
If WScript.Arguments.Count <> 1 Then
    WScript.Echo "Please drag and drop a .txt file onto the script."
    WScript.Quit
End If

strPath = WScript.Arguments.Item(0)
Set objFSO = CreateObject("Scripting.FileSystemObject")

' 检查文件是否存在
If Not objFSO.FileExists(strPath) Then
    WScript.Echo "File does not exist: " & strPath
    WScript.Quit
End If

intErrorCount = 0

' 打开文件进行读取
Set objFile = objFSO.OpenTextFile(strPath, 1)
i = 1
n = 1

Do While Not objFile.AtEndOfStream
    strLine = objFile.ReadLine
    
    ' 检查第n行
    If i Mod 3 = 1 Then
        If Not StartsWith(strLine, "##" & Right("00000" & n, 6) & "##|") Then
             ReportError i, "The line should start with '##' followed by six numbers, followed by '%%|'.or the numbers wrong."
        End If
    ElseIf i Mod 3 = 2 Then
        If Not StartsWith(strLine, "%%" & Right("00000" & n, 6) & "%%|") Then
             ReportError i, "The line should start with '%%' followed by six numbers, followed by '%%|'or the numbers wrong."
        End If
        n = n + 1
    ElseIf i Mod 3 = 0 Then
        If strLine <> "" Then
            ReportError i, "This line should be empty."
        End If
    End If
    
    i = i + 1
Loop

' 检查最后一行是否为空
If strLine <> "" Then
    ReportError i, "The last line should be empty."
End If

objFile.Close

' 没有错误发现
If intErrorCount = 0 Then
    WScript.Echo "No format errors were found."
Else
    WScript.Echo "Total " & intErrorCount & " format error(s) found."
End If

' 检查字符串是否以指定的前缀开始的函数
Function StartsWith(str, prefix)
    StartsWith = Left(str, Len(prefix)) = prefix
End Function

' 报告错误的过程
Sub ReportError(lineNumber, errorMessage)
    WScript.Echo "Error at line " & lineNumber & ": " & errorMessage
    intErrorCount = intErrorCount + 1
End Sub