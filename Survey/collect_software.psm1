function Get-Software {
    [hashtable]$return = @{}
    $return.InstalledSoftware = $(Get-WmiObject Win32_Product | Select-Object Name)
    $return.Processes = $(Get-WmiObject Win32_Process | Select-Object Caption, ProcessId, ParentProcessId, ExecutablePath)

    $return.Drivers = $(Get-WindowsDriver -All -Online | Select-Object Driver, BootCritical, Version, Date, OriginalFileName)

    return $return
}

Export-ModuleMember -Function 'Get-*'