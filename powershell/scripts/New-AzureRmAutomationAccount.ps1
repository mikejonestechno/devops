# Create new Azure Automation Account

$AutomationAccountName  = "AutomationDemo1"
$ResourceGroupName      = "AutomationDemo1RG"
$Location               = "Australia Southeast"


Login-AzureRmAccount


New-AzureRmResourceGroup –Name $ResourceGroupName –Location "$Location"

New-AzureRmAutomationAccount –Name $AutomationAccountName –ResourceGroupName $ResourceGroupName –Location "$Location"
