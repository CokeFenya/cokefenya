# Вывести уведомление в Windows 10/11
[Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] > $null

$template = @"
<toast>
  <visual>
    <binding template='ToastGeneric'>
      <text>Сообщение от скрипта</text>
      <text>Привет! Скрипт успешно запущен.</text>
    </binding>
  </visual>
</toast>
"@

$xml = New-Object Windows.Data.Xml.Dom.XmlDocument
$xml.LoadXml($template)

$toast = [Windows.UI.Notifications.ToastNotification]::new($xml)
$notifier = [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier("ScriptPS1")
$notifier.Show($toast)

# Вывести в консоль
Write-Host "Привет!2"
