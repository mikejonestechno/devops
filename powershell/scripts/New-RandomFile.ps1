<#
.Synopsis
   Create a specified number of files with random name and length
.DESCRIPTION
   Creates .txt files with a random 8 char file name using chars 0-9 and a-f
   The string "PowerShell is awesome! " is repeated a random number of times
   between 1 and 10,000 and added to each file. This generates a reasonably 
   random file length (size) between 23 bytes and 225 KB.
.EXAMPLE
   Create-RandomFiles c:\temp\demo1 10
   Creates the following files in c:\temp\demo1:
        Name         Length
        ----         ------
        03cf833f.txt 183450
        132aefc2.txt 127238
        5182ef76.txt 217421
        8a250083.txt 184485
        8d970d16.txt  59273
        92ac5854.txt  41080
        a88db104.txt 182369
        ac553c98.txt 129239
        e6174611.txt   1543
        f98ad884.txt  54190
.EXAMPLE
   Create-RandomFiles c:\temp\demo2 1000
   Creates 1,000 files in c:\temp\demo2.
   It will take around 40 seconds and files will total around 110MB in size.
#>
function New-RandomFile
{
    [CmdletBinding()]
    Param
    (
        # Path where files will be created
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        $path,

        # Number of files to create
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=1)]
        [int]
        $numberOfFiles
    )

    Begin
    {
    }
    Process
    {
        New-Item $path -ItemType Directory -Force | Out-Null
        While ( (Get-ChildItem $path | Measure-Object).Count -lt $numberOfFiles) { Add-Content -Path ("$path\" + (New-Guid).ToString().Substring(0,8) + ".txt") -Value ("PowerShell is awesome! " * (Get-Random -Maximum 10000)) }
    }
    End
    {
    }
}

New-RandomFile c:\temp\demo1 10