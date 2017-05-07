Given 'the deployment script is successful' {
    # code here to run the script
}

Then 'the machine has 4 CPU logical processors' {
    (Get-WmiObject -Class win32_processor).numberoflogicalprocessors | Should -Be 4
}

Then '8GB of RAM' {
     [Math]::Round((Get-WmiObject -Class win32_computersystem).TotalPhysicalMemory/1Gb) | Should Be 8
}
