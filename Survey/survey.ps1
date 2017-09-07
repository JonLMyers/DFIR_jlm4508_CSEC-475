Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$scriptDir = Split-Path -LiteralPath $(if ($PSVersionTable.PSVersion.Major -ge 3) { $PSCommandPath } else { & { $MyInvocation.ScriptName } })

$stopwatch = [System.Diagnostics.Stopwatch]::StartNew()

try
{
    Import-Module $PSScriptRoot\time.psm1

    $time = Get-Time
    Write-Output "Time: " $time.datetime
    #Write-Output "Timezone: " $time.timezone
    #Write-Output $time.uptime

    $cpu = Get-Hardware

    foreach($drive in $cpu.Drives) {
        Write-Output $drive
    }
    #Write-Output $cpu.ProcessorModel
    #Write-Output $cpu.Memory
}
finally
{
    Write-Output "Done! $($stopwatch.Elapsed)"
}