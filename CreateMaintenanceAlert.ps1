# Requires Az Powershell - Use Install-Module Az to install latest version

$allSubs = Get-AzSubscription

foreach ($sub in $allSubs) {
    Write-Host "👉 Setting Context to subscrption $sub.Id"

    Select-AzSubscription -Subscription $sub.Id    
    New-AzResourceGroup -Name 'global-alerts' -Location 'Global'

    $alertGroup = (New-AzResourceGroupDeployment -Name 'DefaultEmailActionGroup' -ResourceGroupName 'global-alerts' -TemplateFile ./AlertActionGroup.json -actionGroupName 'Planned Maintenance v1' -actionGroupShortName 'emailPlanned')
    $alertRule = (New-AzResourceGroupDeployment -Name 'DefaultEmailActionGroupRule' -ResourceGroupName 'global-alerts' -TemplateFile ./maintainanceAlert.json -actionGroupResourceId $alertGroup.Outputs.actionGroupId.Value) -logAlertName 'Email_Maintenance'
}










