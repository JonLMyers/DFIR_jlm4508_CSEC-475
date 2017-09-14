function Get-Domain {
    [hashtable]$return = @{}

    $DCs = Get-ADDomainController -Filter * 
    $return.hostname = $DCs.Hostname

    foreach ($DC in $DCs.Hostname) {
        $ints = Get-WmiObject -ComputerName $DC -Query “select IPAddress from Win32_NetworkAdapterConfiguration where IPEnabled=TRUE and DHCPEnabled=FALSE”
    
        #lets learn to build a table...
        ForEach ($int in $ints.IPAddress) {
            if ($int.Contains(“.”)) {
                write-output “DC Name: $DC, Static IPv4: $int”
            }
        }
    }
}

Export-ModuleMember -Function 'Get-*'