#============================================================================
#	File:		06 - Scaling up - Several Docker Containers as SQL Cluster.ps1
#
#	Summary:	This script demonstrates how to build a customized image 
#               based on a SQL Server image
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

# Cleanup
kubectl config unset users.kubeuser/clusterUser_k8_summitCluster
kubectl config delete-cluster summitCluster
kubectl config delete-context summitCluster

# Login with Azure Cloud Shell
az login

# Setting the subscription
az account set --subscription 18ed6759-4ea4-46ea-bc2d-e626266af84b

# Create Ressource Group
az group create -l westeurope -n k8

# Create Kubernetes Cluster
az aks create --resource-group k8 --name summitCluster --node-count 4 --kubernetes-version 1.11.3 --generate-ssh-keys

az aks get-credentials --resource-group k8 --name summitCluster

#kubectl config set-credentials kubeuser/myaksclust-k8-18ed67-1dca802e.hcp.westeurope.azmk8s.io --username=kubeuser --password=kubepassword

#kubectl config set-context myAKSCluster --cluster=myAKSCluster --user=clusterUser_k8_myAKSCluster

# Create Namespace
kubectl create namespace summitag

# Configure and deploy the SQL Server operator manifest
kubectl apply -f operator.yaml --namespace summitag

# Create a secret for Kubernetes with passwords for the sa account
kubectl create secret generic sql-secrets --from-literal=sapassword="!test123" --from-literal=masterkeypassword="!test123"  --namespace summitag

# Deploy the SQL Server custom resource
kubectl apply -f sqlserver.yaml --namespace summitag

# Check pods
kubectl get pods --namespace summitag

# Connect to the availability group with the services
kubectl apply -f ag-services.yaml --namespace summitag

# Get IP Address
kubectl get services --namespace summitag

# Use External IP Address from loadbalancer
sqlcmd -S 51.144.176.226 -U sa -P !test123