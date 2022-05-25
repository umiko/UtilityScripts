# This script kills the process of the provided service and restarts it
param($ServiceName)

if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`" $($ServiceName)" -Verb RunAs; exit }
$servicePID = Get-WmiObject -Class Win32_Service -Filter "Name LIKE '$($ServiceName)'" | Select-Object -ExpandProperty ProcessId
$servicePID

Stop-Process -ID $servicePID -Force
Start-Service -Name $ServiceName
