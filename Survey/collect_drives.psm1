function Get-Drives {
    $Drives = Get-WmiObject -Class Win32_LogicalDisk |
        Where-Object {$_.DriveType -ne 5} |
        Sort-Object -Property Name | 
        Select-Object Name, FileSystem, `
            @{"Label"="DiskSize(GB)";"Expression"={"{0:N}" -f ($_.Size/1GB) -as [float]}}, `
            @{"Label"="FreeSpace(GB)";"Expression"={"{0:N}" -f ($_.FreeSpace/1GB) -as [float]}}, `
            @{"Label"="%Free";"Expression"={"{0:N}" -f ($_.FreeSpace/$_.Size*100) -as [float]}} |
        Format-Table -AutoSize
        
    return $Drives
}

Export-ModuleMember -Function 'Get-*'
 