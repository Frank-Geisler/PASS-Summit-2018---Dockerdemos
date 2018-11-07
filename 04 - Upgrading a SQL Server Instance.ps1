#============================================================================
#	File:		04 - Upgrading a SQL Server Instance.ps1
#
#	Summary:	This script demonstrates how to upgrade a SQL Server Instance
#               to a new version with Docker
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

# Create a docker container that has a SQL Server 2017 on it and that uses a mounted volume
docker run --name sqlserverdocker -p 1433:1433 -v sqlvolume:/var/opt/mssql -d  frankgeisler/mssql-server-linux-adventureworks2017

# Show Version of SQL Server
<#

SELECT @@Version 

#>

# Delete SQL Server Container
docker container rm sqlserverdocker -f

# Recreate SQL Server Container. Now with SQL Server 2019 CTP2 and the same volumes
docker run --name sqlserverdocker -e "ACCEPT_EULA=Y" -e "MSSQL_SA_PASSWORD=!demo54321" -p 1433:1433 -v sqlvolume:/var/opt/mssql -d mcr.microsoft.com/mssql/server:vNext-CTP2.0-ubuntu

# Check if the SQL Server is up - the conversion of the master database is carried out automatically
docker container logs sqlserverdocker

# Show Version of SQL Server
<#

SELECT @@Version 

#>

# Migrate SQL Server Database to 2019
<#

ALTER DATABASE AdventureWorks2017
SET
	COMPATIBILITY_LEVEL = 150;
GO 

#>

# Show compatibility level of SQL Server 
<#

SELECT compatibility_level  
FROM sys.databases WHERE name = 'AdventureWorks2017';  
GO 

#>

# Cleanup - Remove Docker volume
docker volume rm sqlvolume
