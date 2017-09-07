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
    Write-Output $cpu.ProcessorName
    #Write-Output $cpu.ProcessorModel
    #Write-Output $cpu.Memory

    $drivesinfo = Get-DiskInfo
    Write-Output $drivesinfo.a
}
finally
{
    Write-Output "Done! $($stopwatch.Elapsed)"
}