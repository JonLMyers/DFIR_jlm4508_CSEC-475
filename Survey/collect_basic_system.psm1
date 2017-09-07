function Get-Time {
    [hashtable]$return = @{}

    $return.datetime = Get-Date -Format U
    $return.timezone = [timezoneinfo]::GetSystemTimeZones() | select id
    $return.uptime = Get-Uptime
    return $return
}

function Get-Uptime {
   $os = Get-WmiObject win32_operatingsystem
   $uptime = (Get-Date) - ($os.ConvertToDateTime($os.lastbootuptime))
   $DisplayUptime = "Uptime: " + $Uptime.Days + " days, " + $Uptime.Hours + " hours, " + $Uptime.Minutes + " minutes" 
   return $DisplayUptime
}

function Get-Version {
    [hashtable]$return = @{}

    $return.versiona = [environment]::OSVersion.Version
    $return.versionb = Get-CimInstance Win32_OperatingSystem | Select-Object  Caption, InstallDate, ServicePackMajorVersion, OSArchitecture
    return $return
}

function Get-Hardware {
    [hashtable]$return = @{}
    $CPUInfo = Get-WmiObject Win32_Processor

    $return.Drives = $CPUInfo.Name
    $return.ProcessorName = $CPUInfo.Name
    $return.ProcessorModel = $CPUInfo.Description
    $return.Memory = Get-WmiObject CIM_PhysicalMemory | Measure-Object -Property capacity -Sum | % { [Math]::Round(($_.sum / 1GB), 2) }
    return $return
}

Export-ModuleMember -Function 'Get-*'