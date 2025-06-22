# Создаем COM объект WScript.Shell
$shell = New-Object -ComObject WScript.Shell

# Отображаем всплывающее уведомление (текст в трее)
$shell.Popup("Привет! Скрипт успешно запущен.", 5, "Сообщение от скрипта", 64)

# Вывод в консоль
Write-Host "Привет!"
