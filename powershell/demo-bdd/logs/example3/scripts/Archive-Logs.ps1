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

# yesterday at 11pm 
#     (Get-Date (get-date -Format d)).AddHours(-1)
# today at 11pm
#     (Get-Date (get-date -Format d)).AddHours(23)

# For directories that have been updated in last 2 days, find files between 11pm yesterday and 11pm today, sort them by size, select the largest 500 and compress them to a .zip file
dir $sourcePath -dir  | where { $_.LastWriteTime -gt (Get-Date).AddDays(-2) } | dir -file -Recurse | where { $_.LastWriteTime -gt (Get-Date (get-date -Format d)).AddHours(-1) -and $_.LastWriteTime -lt (Get-Date (get-date -Format d)).AddHours(23) } | sort length -Descending | select -first $MaxNumberOfFiles | Compress-Archive -DestinationPath $DestFilePath -Force

}
