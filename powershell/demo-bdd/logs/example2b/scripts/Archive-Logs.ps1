function Archive-Logs {

    Param
    (

        [Parameter(Mandatory=$true, Position=0)]
        $sourcePath,

        [Parameter(Mandatory=$true, Position=1)]
        $DestFilePath,

        [Parameter(Mandatory=$true, Position=2)]
        $MaxNumberOfFiles
    )

# Get files, sort them by size, select the largest x number of files and compress them to a .zip file
Get-Item $sourcePath\**\*  | Sort-Object length -Descending | Select-Object -first $MaxNumberOfFiles | Compress-Archive -DestinationPath $DestFilePath -Force

}
