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

Then 'the machine is running Windows (Server |)2012 R2' {
    # See version numbers here https://msdn.microsoft.com/en-us/library/windows/desktop/ms724833(v=vs.85).aspx
    # See SKU edition numbers here http://www.maartendamen.com/2015/06/use-windows-powershell-to-determine-the-windows-edition/
    $OS = Get-CimInstance win32_operatingSystem
    $OS.OSArchitecture      | Should Be "64-bit" 
    $OS.ProductType         | Should BeGreaterThan 1   # 1 = workstation OS, anything > 1 is Server OS
    $OS.Version             | Should BeLike "6.3.*"    # 6.3 = Server 2012 R2|Windows 8.1, 6.1 = Server 2008 R2|Windows 7
    $OS.OperatingSystemSKU  | Should Be 7              # 7 = Standard, 8 = Datacenter, 13 = Standard Core, 4 = Enterprise Edition
}



Then 'the machine is running Windows 7' {
    # See version numbers here https://msdn.microsoft.com/en-us/library/windows/desktop/ms724833(v=vs.85).aspx
    # See SKU edition numbers here http://www.maartendamen.com/2015/06/use-windows-powershell-to-determine-the-windows-edition/
    $OS = Get-CimInstance win32_operatingSystem
    $OS.OSArchitecture      | Should Be "64-bit" 
    $OS.ProductType         | Should BeGreaterThan 0   # 1 = workstation OS, anything > 1 is Server OS
    $OS.Version             | Should BeLike "6.1.*"    # 6.3 = Server 2012 R2|Windows 8.1, 6.1 = Server 2008 R2|Windows 7
    $OS.OperatingSystemSKU  | Should Be 4              # 7 = Standard, 8 = Datacenter, 13 = Standard Core, 4 = Enterprise Edition
}
