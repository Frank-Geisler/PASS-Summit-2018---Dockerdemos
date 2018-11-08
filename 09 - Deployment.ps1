#============================================================================
#	File:		10 - Deployment.ps1
#
#	Summary:	This script demonstrates how to create an Azure Container 
#               Instance and automatically deploy a DACPAC to it
#
#	Datum:		2018-11-06
#
#	PowerShell Version: 5.1
#------------------------------------------------------------------------------
#	Written by: 
#       Tillmann Eitelberg, oh22information services GmbH 
#       Frank Geisler, GDS Business Intelligence GmbH
#
#   This script is intended only as a supplement to demos and lectures
#   given by Tillmann Eitelberg and Frank Geisler.  
#
#   THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF 
#   ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED 
#   TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
#   PARTICULAR PURPOSE.
#============================================================================*/

# Install-Module dbatools
# Install-Module AzureRm.Profile

# $rmprofile = Select-AzureRmProfile -Path "C:\temp\AzureLogin.json"

# if (!$rmprofile) {
    #Save-AzureRmProfile -Path "C:\temp\AzureLogin.json" -Force
#}

#Login-AzureRmAccount
#Set-AzureRmContext -SubscriptionId a83583c4-ea6d-4564-8906-7f646301a498

$resourceGroup = "Docker"
$OsType = "Linux"
$name = "sql01"
$location = "westus"
$envVars = @{ACCEPT_EULA="Y";SA_PASSWORD="!demo54321"}
$DacpacPath = "C:\Users\Tillmann\OneDrive\Vorträge\PASS Summit 2018\PASS Database\Sample\bin\Debug\Sample.dacpac"
$DatabaseName = "Sample"
$PublishProfile = "C:\Users\Tillmann\OneDrive\Vorträge\PASS Summit 2018\PASS Database\Sample\Sample.publish.xml"
$UserName = "sa"
$Password = "!demo54321" | ConvertTo-SecureString -asPlainText -Force

#-Image microsoft/mssql-server-windows-developer `
#-Image microsoft/mssql-server-linux
#-Image frankgeisler/mssql-server-linux-adventureworks2017

New-AzureRmContainerGroup -ResourceGroupName $resourceGroup `
                            -Name $name `
                            -Image microsoft/mssql-server-linux `
                            -OsType $OsType `
                            -DnsNameLabel "$($name)-linux" `
                            -Location $location `
                            -cpu 3 `
                            -memory 3.5 `
                            -IpAddressType Public `
                            -Port 1433 `
                            -EnvironmentVariable $envVars

Write-Host (Get-Date -Format g)
while ((Get-AzureRmContainerGroup -ResourceGroupName $resourceGroup -Name $name).ProvisioningState -ne "Succeeded" -and `
        (Get-AzureRmContainerGroup -ResourceGroupName $resourceGroup -Name $name).State -ne "Running") { }
Write-Host (Get-Date -Format g)

$ipAddress = (Get-AzureRmContainerGroup -ResourceGroupName $resourceGroup -Name $name).IpAddress

Start-Sleep -s 60

$PublishParams = @{
	SqlInstance = $ipAddress
	Path = (Resolve-Path $DacpacPath)
	Database = $DatabaseName
	PublishXml = (Resolve-Path $PublishProfile)
}

if ($UserName) {
	$PublishParams.Add("SqlCredential", (New-Object System.Management.Automation.PSCredential ($UserName, $Password)))
}

$dac = Publish-DbaDacPackage @PublishParams

Write-Host "IP-Address: $($ipAddress)"

# Remove-AzureRmContainerGroup -ResourceGroupName $resourceGroup -Name $name