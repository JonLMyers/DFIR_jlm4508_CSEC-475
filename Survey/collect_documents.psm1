function Get-DocArtifacts {
    [hashtable]$return = @{}

    $users = Get-ChildItem -Path "C:\Users" | Select-Object Name
    foreach ($user in $users) {
        $path = ("C:\Users\" + $user.Name)
        $documents = Get-ChildItem -Path ($path + "\Documents") | Select-Object Name
        $downloads = Get-ChildItem -Path ($path + "\Downloads") | Select-Object Name

        foreach ($document in $documents){
            $return.Documents += $document.Name
        }
        foreach ($download in $downloads){
            $return.Downloads += $download.Name
        }
    }
    $return.Downloads
}
Export-ModuleMember -Function 'Get-*'