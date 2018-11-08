#============================================================================
#	File:		03 - Create a Dockerfile.ps1
#
#	Summary:	This script demonstrates how use a Dockerfile for generating
#               Images
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

# Execute in dockerfile directory

docker build –t newsqlserverimage .

docker images

docker run –d –p 1433:1433 --name newsqlservercontainer newsqlserverimage


