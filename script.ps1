$path = "C:\Users\danil\Desktop\test.txt"
$content = "Это тестовый файл, созданный PowerShell."

# Создаём (или перезаписываем) файл с указанным содержимым
Set-Content -Path $path -Value $content

Write-Host "Файл test.txt успешно создан на рабочем столе."
