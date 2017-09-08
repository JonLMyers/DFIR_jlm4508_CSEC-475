function Get-Networking {
    [hashtable]$return = @{}
    $return.arp = $(Get-NetNeighbor | Select-Object IPAddress, LinkLayerAddress)
    $return.MAC = $(Get-WmiObject Win32_NetworkAdapterConfiguration | Select-Object Description, MACAddress)
    $return.RouteTable = $(Get-NetRoute | Select-Object DestinationPrefix, NextHop)
    $return.IPAddress = $(Get-NetIPAddress | Select-Object InterfaceAlias, IPAddress)
    $return.DHCP = Get-Service -Name DHCPServer
    $return.DNS = $(Get-DnsClientServerAddress | Select-Object ServerAddresses | Get-Unique)
    $return.ListeningServices = $(Get-NetTCPConnection -State Listen)
    $return.EstablishedServices = $(Get-NetTCPConnection -State Established)
    $return.DNSCache = $(Get-DnsClientCache)

    $return.Shares = $(Get-WmiObject Win32_Share)
    $return.Printers = $(Get-WmiObject Win32_Printer | Select-Object Name)
    $return.Wireless = netsh wlan show profiles

    return $return
}

Export-ModuleMember -Function 'Get-*'