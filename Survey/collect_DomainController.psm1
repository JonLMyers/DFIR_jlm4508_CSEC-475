function Get-Domain {
    [hashtable]$return = @{}
    $return.DC = (Get-WmiObject win32_computersystem).Domain
    $return.hostname = (Get-WmiObject win32_computersystem).Name
    $return.dns = Get-DnsClientServerAddress | Select-Object -ExpandProperty ServerAddresses
    return $return
}

function Get-Users {
    [hashtable]$return = @{}

    $adsi = [ADSI]"WinNT://$env:COMPUTERNAME"
    $local = $adsi.Children | Where-Object {$_.SchemaClassName -eq 'user'} |  
        ForEach-Object {
        
            [pscustomobject]@{
                UserName = $_.Name[0]
                SID = ConvertTo-SID -BinarySID $_.ObjectSID[0]
                LastLogin = If ($_.LastLogin[0] -is [datetime]){$_.LastLogin[0]}Else{'Never logged  on'}
            }
        }
        
    return $local
}
Function  ConvertTo-SID {
      Param([byte[]]$BinarySID)
      (New-Object  System.Security.Principal.SecurityIdentifier($BinarySID,0)).Value
}

Export-ModuleMember -Function 'Get-*'