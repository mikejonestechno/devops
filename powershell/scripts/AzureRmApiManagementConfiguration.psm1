<#
.Synopsis
   Get (download and overwrite) all the Azure API Management policies to local 'policies' directory RECURSIVELY.

.DESCRIPTION
   You can use this cmdlet to create a local repository of existing policies in the Azure API Management portal.
   The file names and folders match the structure from the API Management git repository feature.
   
   The reason for using this function instead of the regular API Management git reposity is when you require
   separate audit or governance workflow or environment management. 

.EXAMPLE
   Get-AzureRmApiManagementPolicies -resourceGroupName "apiMgtDemo" -serviceName "demoService" -policiesFilePath "c:\source\repo\api-mgt\policies"

   Results in downloading the following files
   c:\source\repo\api-mgt\policies\global.xml
   c:\source\repo\api-mgt\policies\products\Starter.xml
   c:\source\repo\api-mgt\policies\apis\Echo_API\operations\Create_resource.xml
   c:\source\repo\api-mgt\policies\apis\Echo_API\operations\Retreive_header_only.xml
   c:\source\repo\api-mgt\policies\apis\Echo_API\operations\Retreive_resource_(cached).xml

   The files can be added and managed in an external git repository e.g. VSTS and incorporated into a build and release
   pipeline to deploy policy changes to dev, test and production environments with auditable and approval workflow.
#>
Function Get-AzureRmApiManagementRepositoryPolicy {

    [CmdletBinding()]
    param(

        # Name of resource group under which an API Management service is deployed.
        [Parameter (Mandatory=$true)]
        [string] $ResourceGroupName,

        # Name of deployed API Management service within the specified resource group.
        [Parameter (Mandatory=$true)]
        [string] $ServiceName,

        # Local path to save the xml policy files.
        [Parameter (Mandatory=$true, HelpMessage="Local path to save the xml policy files")]
        [ValidateScript({test-path $_})] 
        [string] $RepositoryFilePath

    )

    <# TODO
            Implement -whatif because remove is destructive or a 'confirm' unless -force is used
            Make this cmdlet like using similar params to recursively get operations from a specified list of apis!
            compare count of server policies and local policies as a quick check if there is a mismatch and additional files to remove
                can we get array of api names and array of api .xml files and compare names match
            Split into a 'recursive' function that just checks the server and local policy names match then
                have a 'get' and a 'set' sub function that pipe stuff from the main function?
    #>


    Process {

        $apimContext = New-AzureRmApiManagementContext -ResourceGroupName $resourceGroupName -ServiceName $serviceName

        $globalPolicyFile = "$RepositoryFilePath\global.xml"
        Write-Output "Saving Global policy"
        Get-AzureRmApiManagementPolicy -Context $apimContext -SaveAs $globalPolicyFile -Force


        $products = Get-AzureRmApiManagementProduct -Context $apimContext
        Foreach ($product in $products)
        {
            $productId = $product.ProductId
            Write-Output "Found Product ID $productId '$($product.Title)'"
            $productPolicyXml = Get-AzureRmApiManagementPolicy -Context $apimContext -ProductId $productId

            $productFileBaseName = $($product.Title).Replace(" ","_")
            $productPolicyFile = "$($RepositoryFilePath)\products\$($productFileBaseName).xml"   
            If ($productPolicyXml.Length -gt 1) {
                Write-Verbose "Creating directory"
                New-Item -Path "$($RepositoryFilePath)\products" -ItemType Directory -Force
                Write-Output "Saving file $productPolicyFile"
                $productPolicyXml | Out-File $productPolicyFile -Force
            } else {
                Remove-Item $productPolicyFile -Force
            }

        }

        $apis = Get-AzureRmApiManagementApi -Context $apimContext
        Foreach ($api in $apis)
        {
            $apiId = $api.ApiId
            Write-Output "Found API '$($api.Name)'"
            $appPolicyXml = Get-AzureRmApiManagementPolicy -Context $apimContext -ApiId $apiId 
            $apiFileBaseName = $($api.Name).Replace(" ","_")
            $apiPolicyFile = "$($RepositoryFilePath)\apis\$($apiFileBaseName).xml"  

            If ($apiPolicyXml.Length -gt 1) {
                Write-Verbose "Creating directory"
                New-Item -Path "$($RepositoryFilePath)\apis" -ItemType Directory -Force
                Write-Output "Saving file $apiPolicyFile"
                $apiPolicyXml | Out-File $apiPolicyFile -Force
            } else {
                Remove-Item $apiPolicyFile -Force
            }

            $operations = Get-AzureRmApiManagementOperation -Context $apimContext -ApiId $apiId
            Foreach ($operation in $operations)
            {                                                            
                $operationId = $operation.OperationId
                Write-Output "Found API '$($api.Name)' Operation '$($operation.Name)'"
                $operationPolicyXml = Get-AzureRmApiManagementPolicy -Context $apimContext -ApiId $apiId -OperationId $operationId
                $operationFileBaseName = $($operation.Name).Replace(" ","_")
                $operationPolicyFile = "$($RepositoryFilePath)\apis\$($apiFileBaseName)\operations\$($operationFileBaseName).xml"

                if ($operationPolicyXml.Length -gt 1) {
                    Write-Verbose "Creating directory"
                    New-Item -Path "$($RepositoryFilePath)\apis\$($apiFileBaseName)\operations" -ItemType Directory -Force
                    Write-Output "Saving $operationPolicyFile"
                    $operationPolicyXml | Out-File $operationPolicyFile -Force       
                } else {
                    Remove-Item $operationPolicyFile -Force
                }
             }  

        }

    }
}