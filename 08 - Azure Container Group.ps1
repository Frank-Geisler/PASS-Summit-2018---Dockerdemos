#============================================================================
#	File:		08 - Azure Container Group.ps1
#
#	Summary:	This script demonstrates how to create an Azure Container 
#               Instance
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


# Login-AzureRmAccount
# Set-AzureRmContext -SubscriptionId a83583c4-ea6d-4564-8906-7f646301a498

$resourceGroup = "Docker"
$OsType = "Linux"
$name = "sql01"
$location = "westus"
$envVars = @{ACCEPT_EULA="Y";SA_PASSWORD="!demo54321"}

<#

docker run --name sqlserverdocker -p 1433:1433 -d  frankgeisler/mssql-server-linux-adventureworks2017

#>


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

