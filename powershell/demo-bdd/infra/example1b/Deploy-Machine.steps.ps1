Given 'the deployment script is successful' {
    # code here to run the script
}

Then '(the machine has |)(?<expectedProcessors>\d+) CPU logical processors' {
    param($expectedProcessors)
    (Get-WmiObject -Class win32_processor).numberoflogicalprocessors | Should -Be $expectedProcessors 
}

Then '(the machine has |)(?<expectedRam>\d+)GB of RAM' {
     param($expectedRam)
     [Math]::Round((Get-WmiObject -Class win32_computersystem).TotalPhysicalMemory/1Gb) | Should Be $expectedRam
}
