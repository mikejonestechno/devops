$myAutomationRG = "AzureDSC"
$myAutomationAccount = "AzureDSC"
$sourcePath = "dsc"
$configurationName = "SonarQube"

Login-AzureRmAccount

Import-AzureRmAutomationDscConfiguration `
    -SourcePath "$sourcePath\$configurationName.ps1" `
    -ResourceGroupName $myAutomationRG –AutomationAccountName $myAutomationAccount  `
    -Published –Force

$jobData = Start-AzureRmAutomationDscCompilationJob -ConfigurationName $configurationName `
    -ResourceGroupName $myAutomationRG –AutomationAccountName $myAutomationAccount 

$compilationJobId = $jobData.Id

Get-AzureRmAutomationDscCompilationJob -ResourceGroupName $myAutomationRG –AutomationAccountName $myAutomationAccount -Id $compilationJobId
