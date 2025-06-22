# Проверка, запущен ли PowerShell с правами администратора
If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltinRole] "Administrator"))
{
    Write-Host "Скрипт запущен НЕ от администратора." -ForegroundColor Red
}
else
{
    Write-Host "Скрипт запущен ОТ администратора." -ForegroundColor Green
}
Pause
