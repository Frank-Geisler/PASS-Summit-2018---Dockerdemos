#============================================================================
#	File:		01 - SQL Server Container.ps1
#
#	Summary:	This script demonstrates how to instanciate a SQL Server
#               container with docker
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

docker pull microsoft/mssql-server-linux:latest

#-----------------------------------------------------------------------------
# The docker command for readibility reasons 
#
# docker run --name sqldemoserver 
#    -p 1433:1433 
#    -e "ACCEPT_EULA=Y" 
#    -e "SA_PASSWORD=!test123" 
#    -d 
#    microsoft/mssql-server-linux:latest
#------------------------------------------------------------------------------

# Search for SQL Server related images on Docker Hub
docker search microsoft/mssql

# Pull SQL Server Image from Docker Hub
docker pull microsoft/mssql-server-linux

# Check Docker Images
docker images ls

# Run SQL Server Container
docker run --name sqldemoserver -p 1433:1433 -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=!test123" -d microsoft/mssql-server-linux:latest

# Connect via SSMS
<#
SELECT @@Version
#>

# Check Container
docker container ls 

# Examine Container
docker inspect sqldemoserver

# Connect to container
docker exec –it sqldemoserver bash

# Copy file to container
docker cp C:\Temp\Docker\sqlserver\WideWorldImporters-Full.bak sqldemoserver:/var/opt/mssql/data/WideWorldImporters-Full.bak

# Restore Database via SSMS

# Convert Docker Container to Image
docker commit sqldemoserver frankgeisler/passsummitsqltest

# Remove Container
docker rm -f sqldemoserver