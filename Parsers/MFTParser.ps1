#Parses a MFT2CSV CSV file and extracts the timestamps, filetypes, and path
function ParseCSV( $csv ){
    $Files = Import-Csv -Path $csv -Delimiter "," #If your dump uses a different delimiter change it.
    
    ForEach ($File in $Files){
        $File | Select-Object -Property Timestamp, FileType, Path | Format-Table -Auto
   
    }
}

#Dumps the $DATA section of a specified file
function DumpData( $file ){
    $data = "$(((Get-ChildItem $Path -Include "*$file" -Recurse).FullName).Replace("[","``[").Replace("]","``]").Replace("$file ", "$file    "))".Split("    ") 
    $data | Format-Table -Auto
}

$Parse = $true  #Use this to decide if you are going to dump or parse
$CsvPath = 'C:\Users\forensics\Desktop\dump.csv'    # Set the path for the CSV dump
$file = 'C:\Users\forensics\Desktop\file.txt'  #Whatever file you want to dump the $DATA from

if ($Parse -eq $true){
    ParseCSV()
}
else {
    DumpData($file)   
}
