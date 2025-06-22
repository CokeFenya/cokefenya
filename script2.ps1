# === Настройки ===
$server = "http://5.158.121.185:4200/api"
$versionUrl = "$server/version"
$downloadUrl = "$server/download"
$regPath = "HKCU:\Software\Zapret"
$regKey = "version"
$savePath = "$env:LOCALAPPDATA\Zapret\zapret.exe"
$serviceName = "ZapretService"

# Создаем папку для сохранения, если нет
if (!(Test-Path -Path (Split-Path $savePath))) {
    New-Item -ItemType Directory -Force -Path (Split-Path $savePath) | Out-Null
}

# Получаем текущую версию из реестра HKCU:\Software\Zapret
$currentVersion = ""
if (Test-Path $regPath) {
    try {
        $currentVersion = (Get-ItemProperty -Path $regPath -Name $regKey -ErrorAction SilentlyContinue).$regKey
    } catch {}
}

# Получаем версию с сервера
try {
    $remoteVersion = Invoke-RestMethod -Uri $versionUrl -UseBasicParsing
} catch {
    Write-Host "Не удалось получить версию с сервера: $_"
    exit 1
}

# Проверяем необходимость обновления
$needUpdate = $false
if ([string]::IsNullOrEmpty($currentVersion)) {
    $needUpdate = $true
} elseif ($remoteVersion -ne $currentVersion) {
    $needUpdate = $true
}

if ($needUpdate) {
    try {
        Write-Host "Скачиваем файл с $downloadUrl..."
        Invoke-WebRequest -Uri $downloadUrl -OutFile $savePath -UseBasicParsing
        Write-Host "Файл сохранён в $savePath"
    } catch {
        Write-Host "Ошибка при скачивании файла: $_"
        exit 1
    }

    # Записываем новую версию в реестр
    if (!(Test-Path $regPath)) {
        New-Item -Path $regPath -Force | Out-Null
    }
    Set-ItemProperty -Path $regPath -Name $regKey -Value $remoteVersion
    Write-Host "Версия $remoteVersion записана в реестр"
}

# Проверяем существование сервиса
$serviceCheck = sc.exe query $serviceName 2>&1
$serviceNotExist = $serviceCheck | Select-String "does not exist"

if ($serviceNotExist) {
    Write-Host "Создаём сервис $serviceName"
    sc.exe create $serviceName binPath= "`"$savePath`"" start= delayed-auto
    sc.exe description $serviceName "Запретный сервис"
} else {
    Write-Host "Сервис $serviceName уже существует"
}

# Запускаем сервис (если уже запущен - не ошибка)
$startResult = sc.exe start $serviceName 2>&1
if ($startResult -match "FAILED") {
    Write-Host "Сервис не запустился или уже запущен: $startResult"
} else {
    Write-Host "Сервис $serviceName запущен"
}
