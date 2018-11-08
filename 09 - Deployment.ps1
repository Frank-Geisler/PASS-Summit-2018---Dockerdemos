# Install-Module dbatools
Login-AzureRmAccount
Set-AzureRmContext -SubscriptionId a83583c4-ea6d-4564-8906-7f646301a498

$resourceGroup = "Docker"
$OsType = "Linux"
$name = "sql01"
$location = "westus"
$envVars = @{ACCEPT_EULA="Y";SA_PASSWORD="!demo54321"}
$DacpacPath = "C:\Users\Tillmann\OneDrive\Vorträge\PASS Summit 2018\PASS Database\Sample\bin\Debug\Sample.dacpac"
$DatabaseName = "Sample"
$PublishProfile = "C:\Users\Tillmann\OneDrive\Vorträge\PASS Summit 2018\PASS Database\Sample\Sample.publish.xml"
$GenerateDeploymentScript
$UserName = "sa"
$Password = "!demo54321" | ConvertTo-SecureString -asPlainText -Force

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

$PublishParams = @{
	SqlInstance = $ipAddress
	Path = (Resolve-Path $DacpacPath)
	Database = $DatabaseName
	PublishXml = (Resolve-Path $PublishProfile)
}

if ($UserName) {
	$PublishParams.Add("SqlCredential", (New-Object System.Management.Automation.PSCredential ($UserName, $Password)))
}

Publish-DbaDacPackage @PublishParams