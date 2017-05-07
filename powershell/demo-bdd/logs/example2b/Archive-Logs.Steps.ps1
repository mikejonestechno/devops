$here = Split-Path -Parent $MyInvocation.MyCommand.Path

Add-Type -Path "C:\Program Files (x86)\Reference Assemblies\Microsoft\Framework\.NETFramework\v4.5\System.IO.Compression.FileSystem.dll"

Given 'the source directory contains (?<numberOfFiles>\d+) files' {
        param($numberOfFiles)

        $sourcePath     = Join-Path $TestDrive  "source"
        $sourceDataPath = Join-Path $sourcePath "data"

        $destPath       = Join-Path $TestDrive  "destpath"
        $destFilePath   = Join-Path $destPath   "myTest.zip"

        # create new source and dest paths
        New-Item -Path $sourcePath -ItemType Directory | Out-Null
        New-Item -Path $sourceDataPath -ItemType Directory | Out-Null
        New-Item -Path $destPath -ItemType Directory | Out-Null

        # Add a large number of files with random file names and sizes
        While ( (Get-ChildItem $sourceDataPath | Measure-Object).Count -lt $numberOfFiles) { 
            Add-Content -Path ("$sourceDataPath\" + (New-Guid).ToString().Substring(0,8) + ".log") -Value ("PowerShell is awesome! " * (Get-Random -Maximum 10000)) 
        }
        $maxFiles = 500
}


Then 'the archive contains (?<maxFiles>\d+) files' {
    param($maxFiles)
    $zip =  [System.IO.Compression.ZipFile]::OpenRead($destFilePath)           
    $zipCount = $zip.entries.count 
    $zip.Dispose() # dispose file lock before we test the count otherwise exceptions/failed test will leave the file locked
    $zipCount | Should Be $maxFiles
}


When 'I run archive-script.ps1' {
        . .\$here\scripts\Archive-Logs.ps1   
        Archive-Logs -sourcePath $sourcepath -DestFilePath $destFilePath -MaxNumberOfFiles $maxFiles
}

Given 'the source directory contains the following files' {
    Param($table)
        $sourcePath = Join-Path $TestDrive "source"
        $sourceDataPath = Join-Path $sourcePath "data"

        $destPath = Join-Path $TestDrive "destpath"
        $destFilePath="$destPath\myTest.zip"

        # create new source and dest paths
        New-Item -Path $sourcePath -ItemType Directory | Out-Null
        New-Item -Path $sourceDataPath -ItemType Directory | Out-Null
        New-Item -Path $destPath -ItemType Directory | Out-Null

        foreach ($row in $table) {
            Add-Content -Path "$sourceDataPath\$($row.name).log" -Value ("1" * $($row.size))
        }
        $maxFiles = 5
}


Then 'the archive contains exactly these files' {
        Param($table)

        # Expand the .zip so that we can test the file contents
        $expandPath = Join-Path $destPath "expand"          
        New-Item $expandPath -ItemType Directory | Out-Null

        Expand-Archive -Path $destFilePath -DestinationPath $expandPath

        # Test that it contains exactly 
        foreach ($row in $table) {
            Test-Path "$($expandPath)\$($row.name).log" | Should Be True
        }
        Get-ChildItem $expandPath | Measure-Object | % {$_.Count} | Should Be $table.count
}

