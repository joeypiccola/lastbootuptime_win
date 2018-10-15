$query = Get-WmiObject -class Win32_OperatingSystem | Select-Object @{ Name = 'LastBootUpTime'; Expression = { ($_.ConvertToDateTime($_.LastBootUpTime)).tostring() }}, @{ Name = 'lastbootuptime_wmi'; Expression = { $_.LastBootUpTime.tostring() }}
$fact = [PSCustomObject]@{
    lastbootuptime     = $query.LastBootUpTime
    lastbootuptime_wmi = $query.lastbootuptime_wmi
}
$factContent = $fact | ConvertTo-Json
$factPath = 'C:\ProgramData\PuppetLabs\facter\facts.d\lastbootuptime.json'
$Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding $False
[System.IO.File]::WriteAllLines($factPath, $factContent, $Utf8NoBomEncoding)