Login-AzureRmAccount
Set-AzureRmContext -SubscriptionId a83583c4-ea6d-4564-8906-7f646301a498

$resourceGroup = "Docker"
$OsType = "Linux"
$name = "sql01"
$location = "westus"
$envVars = @{ACCEPT_EULA="Y";SA_PASSWORD="!dmeo54321"}

#-Image microsoft/mssql-server-windows-developer `
#-Image frankgeisler/mssql-server-linux-adventureworks2017
#-Image microsoft/iis:nanoserver `

New-AzureRmContainerGroup -ResourceGroupName $resourceGroup `
                            -Name $name `
                            -Image frankgeisler/mssql-server-linux-adventureworks2017 `
                            -OsType $OsType `
                            -DnsNameLabel "$($name)-linux" `
                            -Location $location `
                            -cpu 3 `
                            -memory 3.5 `
                            -IpAddressType Public `
                            -Port 1433 `
                            -EnvironmentVariable $envVars

Write-Host (Get-Date -Format g)
while ((Get-AzureRmContainerGroup -ResourceGroupName $resourceGroup -Name $name).ProvisioningState -eq "Creating") { }
Write-Host (Get-Date -Format g)

$ipAddress = (Get-AzureRmContainerGroup -ResourceGroupName $resourceGroup -Name $name).IpAddress
Write-Host $ipAddress

#Remove-AzureRmContainerGroup -ResourceGroupName $resourceGroup -Name $name

