' Krishan POS Dedicated Desktop Application Runner
Option Explicit
Dim WshShell, fso, currentDir, http, isRunning, processId, objProcess, appLaunched

Set WshShell = CreateObject("WScript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")
currentDir = fso.GetParentFolderName(WScript.ScriptFullName)

' Set Current Working Directory
WshShell.CurrentDirectory = currentDir

isRunning = False

' Check if local server is already running by attempting a quick GET request
On Error Resume Next
Set http = CreateObject("MSXML2.ServerXMLHTTP.6.0")
If Err.Number = 0 Then
    http.open "GET", "http://127.0.0.1:3000/api/network-info", False
    http.setTimeouts 800, 800, 800, 800
    http.send
    If Err.Number = 0 Then
        If http.Status = 200 Then
            isRunning = True
        End If
    End If
End If
Err.Clear
On Error GoTo 0

' If not running, start server silently in background
If Not isRunning Then
    On Error Resume Next
    Set objProcess = GetObject("winmgmts:Win32_Process")
    objProcess.Create "node server.js", currentDir, Null, processId
    If Err.Number <> 0 Then
        Err.Clear
        WshShell.Run "cmd /c cd /d """ & currentDir & """ && node server.js", 0, False
    End If
    On Error GoTo 0
    WScript.Sleep 2000
End If

' Launch Krishan POS in Dedicated Standalone Desktop App Window (No Browser Address Bar / No Tabs)
appLaunched = False

If fso.FileExists("C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe") Then
    WshShell.Run """C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"" --app=http://localhost:3000 --window-size=1280,850", 1, False
    appLaunched = True
ElseIf fso.FileExists("C:\Program Files\Microsoft\Edge\Application\msedge.exe") Then
    WshShell.Run """C:\Program Files\Microsoft\Edge\Application\msedge.exe"" --app=http://localhost:3000 --window-size=1280,850", 1, False
    appLaunched = True
ElseIf fso.FileExists("C:\Program Files\Google\Chrome\Application\chrome.exe") Then
    WshShell.Run """C:\Program Files\Google\Chrome\Application\chrome.exe"" --app=http://localhost:3000 --window-size=1280,850", 1, False
    appLaunched = True
ElseIf fso.FileExists("C:\Program Files (x86)\Google\Chrome\Application\chrome.exe") Then
    WshShell.Run """C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"" --app=http://localhost:3000 --window-size=1280,850", 1, False
    appLaunched = True
End If

If Not appLaunched Then
    WshShell.Run "cmd /c start msedge --app=http://localhost:3000 || start chrome --app=http://localhost:3000 || start http://localhost:3000", 0, False
End If
