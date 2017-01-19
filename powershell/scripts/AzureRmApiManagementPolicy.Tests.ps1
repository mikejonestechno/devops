$here = Split-Path -Parent $MyInvocation.MyCommand.Path
# $sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
# . "$here\$sut"

Describe "security policy for policy files" {

    $files = Get-ChildItem -Path "$here\policies" -Filter "*.xml" -Recurse

    foreach ($f in $files) {
        Context "$($f.FullName)" {

            # Get the file content ONCE then assert multiple tests
            $content = Get-Content $f.FullName


            It "Content is well formed XML" {
                ($content) -as [xml] | Should BeOfType Xml
            }


            It "Uses properties for password values" {
                # Password = "abc123" is NOT ok
                # Password = "{{myPasswordProperty}}" is ok
                $passwordUsingProperty = "password\s*=\s*[`"'][{]{2}\w*[}]{2}"
                # 
                !(Select-String -InputObject $content -Pattern "password" -Quiet) -or (Select-String -InputObject $content -Pattern $passwordUsingProperty -Quiet) | Should be $true
            }

            
        }

    }

}
