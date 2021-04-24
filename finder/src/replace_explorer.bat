reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /f /v Shell /t REG_SZ  /d finder.exe
copy /Y C:\Windows\SysWOW64\finder.exe C:\Windows\System32\finder.exe
taskkill /f /IM explorer.exe
C:\Windows\System32\finder.exe