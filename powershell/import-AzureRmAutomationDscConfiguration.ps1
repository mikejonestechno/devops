# Import a DSC configuration to Azure AND compile it so it can be assigned to a node

param(
    [Parameter(Mandatory=$true)]
    [String] $AutomationAccountName,
    
    [Parameter(Mandatory=$true)]
    [String] $ResourceGroupName,
   
    [Parameter(Mandatory=$true)]
    [String] $ConfigName  # Config file name must match the name of the configuration
 )

Login-AzureRmAccount

Import-AzureRmAutomationDscConfiguration -SourcePath "dsc\$ConfigName.ps1" -Published -Force `
  -AutomationAccountName $AutomationAccountName -ResourceGroupName $ResourceGroupName 

$jobData = Start-AzureRmAutomationDscCompilationJob -ConfigurationName $ConfigName `
  -AutomationAccountName $AutomationAccountName -ResourceGroupName $ResourceGroupName 

$compilationJobId = $jobData.Id

Get-AzureRmAutomationDscCompilationJob -Id $compilationJobId `
  -AutomationAccountName $AutomationAccountName -ResourceGroupName $ResourceGroupName 
