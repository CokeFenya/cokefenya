$path = "C:\Users\danil\Desktop\test.txt"

# Проверяем, запущен ли скрипт от имени администратора
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

# Формируем содержимое
if ($isAdmin) {
    $content = "Скрипт запущен с правами администратора."
} else {
    $content = "Скрипт запущен без прав администратора."
}

# Записываем в файл (создаёт или перезаписывает)
Set-Content -Path $path -Value $content

Write-Host "Файл test.txt успешно создан на рабочем столе с информацией о правах."
