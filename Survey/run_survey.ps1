Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$scriptDir = Split-Path -LiteralPath $(if ($PSVersionTable.PSVersion.Major -ge 3) { $PSCommandPath } else { & { $MyInvocation.ScriptName } })
$stopwatch = [System.Diagnostics.Stopwatch]::StartNew()

try {
    Import-Module $PSScriptRoot\collect_basic_system.psm1
    Import-Module $PSScriptRoot\collect_drives.psm1

    $time = Get-Time
    Write-Output "Time: " $time.datetime
    #Write-Output "Timezone: " $time.timezone
    #Write-Output $time.uptime

    $cpu = Get-Hardware
    #Write-Output $cpu.ProcessorModel
    #Write-Output $cpu.Memory

    $drives = Get-Drives
    Write-Output $drives

}
finally {
    Write-Output "Done! $($stopwatch.Elapsed)"
}