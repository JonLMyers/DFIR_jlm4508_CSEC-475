Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$scriptDir = Split-Path -LiteralPath $(if ($PSVersionTable.PSVersion.Major -ge 3) { $PSCommandPath } else { & { $MyInvocation.ScriptName } })
$stopwatch = [System.Diagnostics.Stopwatch]::StartNew()

try {
    Import-Module $PSScriptRoot\collect_basic_system.psm1
    Import-Module $PSScriptRoot\collect_drives.psm1
    Import-Module $PSScriptRoot\collect_DomainController.psm1
    Import-Module $PSScriptRoot\collect_software.psm1
    Import-Module $PSScriptRoot\collect_documents.psm1
    Import-Module $PSScriptRoot\collect_networking

    $MakeCSV = $false
    $SendEmail = $false
    $EmailUserCreds = "Test"
    $EmailServer = "Test"

    $CSVArray = New-Object System.Collections.ArrayList
    # I should have broken the modules into the tables I wanted to print.  Oh well.
    $Time = Get-Time
    $CSVArray.Add($Time)
    print_table "Time" $Time

    $Version = Get-Version
    $CSVArray.Add($Version)
    print_table "Version" $Version

    $Hardware = Get-Hardware
    $CSVArray.Add($Hardware)
    print_table "Hardware" $Hardware

    $Drives = Get-Drives
    $CSVArray.Add($Drives)
    print_table "Drives" $Drives

    $Domain = Get-Domain
    $CSVArray.Add($Domain)
    print_table "Domain Information" $Domain

    $Users = Get-Users
    $CSVArray.Add($Users)
    print_table "User Information" $Users

    $Networking = Get-Networking
    $CSVArray.Add($Networking)
    print_table "Network Information" $Networking
    
    $Software = Get-Software
    $CSVArray.Add($Software)
    print_table "Software Information" $Software

    $Docs = Get-DocArtifacts
    $CSVArray.Add($Docs)
    print_table "Documents" $Docs

    if ($MakeCSV -ne $false) {
        $CSVArray | Export-Csv $scriptDir\survey.csv
    }

    if ($SendEmail -ne $false) {
        #Send-MailMessage 
    }
}
finally {
    Write-Output "Done! $($stopwatch.Elapsed)"
}
