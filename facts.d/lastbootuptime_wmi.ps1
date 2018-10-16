$query = Get-WmiObject -class Win32_OperatingSystem | Select-Object @{ Name = 'LastBootUpTime'; Expression = { ($_.ConvertToDateTime($_.LastBootUpTime)).tostring() }}, @{ Name = 'lastbootuptime_wmi'; Expression = { $_.LastBootUpTime.tostring() }}
Write-Output Write-Output "lastbootuptime_wmi=$($query.lastbootuptime_wmi)"