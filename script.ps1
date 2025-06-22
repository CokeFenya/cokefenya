[Console]::OutputEncoding = [Text.UTF8Encoding]::new()

if ((New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator))
{
    Write-Host "Скрипт запущен от имени администратора"
}
else
{
    Write-Host "Скрипт НЕ запущен от имени администратора"
}

Write-Host "Нажмите Enter для выхода..."
Read-Host
