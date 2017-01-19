[CmdletBinding()]
param(

[Parameter (Mandatory=$true)]
[string] $resourceGroupName,

[Parameter (Mandatory=$true)]
[string] $serviceName,

[Parameter (Mandatory=$true)]
[string] $policiesFilePath

)


$apimContext = New-AzureRmApiManagementContext -ResourceGroupName $resourceGroupName -ServiceName $serviceName

$globalPolicyFile = "$policiesFilePath\global.xml"
If (Test-Path $globalPolicyFile) 
{
    Write-Output "Setting Global policy"
    Set-AzureRmApiManagementPolicy -Context $apimContext -PolicyFilePath $globalPolicyFile 
}

$products = Get-AzureRmApiManagementProduct -Context $apimContext
Foreach ($product in $products)
{
    Write-Output "Found Product '$($product.Title)'"
    $productId = $product.ProductId
    $productFileBaseName = $($product.Title).Replace(" ","_")
    $productPolicyFile = "$($policiesFilePath)\products\$($productFileBaseName).xml"
    If (Test-Path $productPolicyFile)
    {
        Write-Output "Setting policy for product ID $productId"
        Set-AzureRmApiManagementPolicy -Context $apimContext -ProductId $productId -PolicyFilePath $productPolicyFile 
    }
    Else
    {
        Write-Verbose "Could not find policy file $productPolicyFile"
        Write-Output "Removing policy for product ID $productId"
        Remove-AzureRmApiManagementPolicy -Context $apimContext -ProductId $productId
    }

}

$apis = Get-AzureRmApiManagementApi -Context $apimContext
Foreach ($api in $apis)
{
    Write-Output "Found API '$($api.Name)'"
    $apiId = $api.ApiId
    $apiFileBaseName = $($api.Name).Replace(" ","_")
    $apiPolicyFile = "$($policiesFilePath)\apis\$($apiFileBaseName).xml"  
    If (Test-Path $apiPolicyFile)
    {
        Write-Output "Setting policy for API ID $apiId"
        Set-AzureRmApiManagementPolicy -Context $apimContext -ApiId $apiId -PolicyFilePath $apiPolicyFile 
    }
    Else
    {
        Write-Verbose "Could not find policy file $apiPolicyFile"
        Write-Output "Removing policy for API ID $apiId"
        Remove-AzureRmApiManagementPolicy -Context $apimContext -ApiId $apiId 
    }


    $operations = Get-AzureRmApiManagementOperation -Context $apimContext -ApiId $apiId
    Foreach ($operation in $operations)
    {                                                            
        Write-Output "Found API '$($api.Name)' Operation '$($operation.Name)'"
        $operationId = $operation.OperationId
        $operationFileBaseName = $($operation.Name).Replace(" ","_")
        $operationPolicyFile = "$($policiesFilePath)\apis\$($apiFileBaseName)\operations\$($operationFileBaseName).xml"
        If (Test-Path $operationPolicyFile)
        {
            Write-Output "Setting policy for Operation ID $operationId"
            Set-AzureRmApiManagementPolicy -Context $apimContext -ApiId $apiId -OperationId $operationId -PolicyFilePath $operationPolicyFile 
        }
        Else
        {
            Write-Verbose "Could not find policy file $operationPolicyFile"
            Write-Output "Removing policy for Operation ID $operationId"
            Remove-AzureRmApiManagementPolicy -Context $apimContext -ApiId $apiId -OperationId $operationId
        }
       
     }  

}


