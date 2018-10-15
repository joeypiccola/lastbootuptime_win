Param(
    [Parameter()]
    [int]$timeout = 900,
    [Parameter(Mandatory)]
    [string]$puppetdbapitoken,
    [Parameter(Mandatory)]
    [string]$node,
    [Parameter(Mandatory)]
    [string]$puppetmaster
)

$ErrorActionPreference = 'stop'

Function Get-PuppetNodeFact {
    Param(
        [Parameter(Mandatory)]
        [string]$Token,
        [Parameter(Mandatory)]
        [string]$Master,
        [Parameter(Mandatory)]
        [string]$Node,
        [Parameter(Mandatory)]
        [string]$Fact
    )

    # This is a shortcut to the /pdb/query/v4/facts endpoint.
    $hoststr = "https://$master`:8081/pdb/query/v4/nodes/$node/facts/$Fact"
    $headers = @{'X-Authentication' = $Token}

    $result = Invoke-WebRequest -Uri $hoststr -Method Get -Headers $headers
    $content = $result.content | ConvertFrom-Json

    Write-Output $content.value
}

$lastBootUpTime_current = Get-PuppetNodeFact -Token $puppetdbapitoken -Master $puppetmaster -Node $node -Fact 'lastbootuptime_wmi'

# create a timespan
$timespan = New-TimeSpan -Seconds $timeout
# start a timer
$stopwatch = [diagnostics.stopwatch]::StartNew()

while ($stopwatch.elapsed -le $timespan) {
    $lastBootUpTime_now = Get-PuppetNodeFact -Token $puppetdbapitoken -Master $puppetmaster -Node $node -Fact 'lastbootuptime_wmi'
    if ($lastBootUpTime_current -ne $lastBootUpTime_now) {
        $stopwatch.stop()
        exit 0
    }
    Start-Sleep -Seconds 30
}

if ($stopwatch.elapsed -ge $timespan) {
    Write-Error "Timeout of $timeout`s has been exceeded. Time elapsed $($stopwatch.Elapsed.Seconds)."
    exit 1
}