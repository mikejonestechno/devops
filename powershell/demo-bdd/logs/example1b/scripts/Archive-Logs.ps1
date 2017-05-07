function Archive-Logs {

    Param
    (
        [Parameter(Mandatory=$true, Position=0)]
        $sourcePath,

        [Parameter(Mandatory=$true, Position=1)]
        $DestFilePath
    )

# Get 500 files and compress them to a .zip file
Get-Item $sourcePath\**\* | Select-Object -First 500 | Compress-Archive -DestinationPath $DestFilePath -Force

}
