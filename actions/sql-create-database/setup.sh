#!/bin/bash

# required parameters in ENV:
# AZURE_SP_NAME
# AZURE_SP_TENANT
# AZURE_SP_PASSWORD
# AZURE_RESOURCE_GROUP
# AZURE_REGION
# SQL_SERVER
# SQL_DATABASE
# SQL_PASSWORD

# login
az login --service-principal -u $AZURE_SP_NAME -p $AZURE_SP_PASSWORD --tenant $AZURE_SP_TENANT > /dev/null

# create RG:
az group show --name $AZURE_RESOURCE_GROUP > /dev/null
if [ $? != 0 ]; then
	echo "Creating new resource group: $AZURE_RESOURCE_GROUP"	
    az group create --name $AZURE_RESOURCE_GROUP --location $AZURE_REGION > /dev/null
else
	echo "Using existing resource group: $AZURE_RESOURCE_GROUP"
fi

# create server:
az sql server show --name $SQL_SERVER --resource-group $AZURE_RESOURCE_GROUP > /dev/null
if [ $? != 0 ]; then
	echo "Creating SQL Server: $SQL_SERVER in resource group: $AZURE_RESOURCE_GROUP"

	az sql server create \
      --name $SQL_SERVER \
      --resource-group $AZURE_RESOURCE_GROUP \
      --location $AZURE_REGION  \
      --admin-user ServerAdmin \
      --admin-password $SQL_PASSWORD

    az sql server firewall-rule create \
      --resource-group $AZURE_RESOURCE_GROUP \
      --server $SQL_SERVER \
      -n AllowAzure \
      --start-ip-address 0.0.0.0 \
      --end-ip-address 0.0.0.0

else
	echo "Using existing SQL Server: $SQL_SERVER"
fi

# create db:
az sql db show --name $SQL_DATABASE --server $SQL_SERVER --resource-group $AZURE_RESOURCE_GROUP > /dev/null
if [ $? != 0 ]; then
	echo "Creating SQL database: $SQL_DATABASE in server: $SQL_SERVER"

    az sql db create \
      --resource-group $AZURE_RESOURCE_GROUP \
      --server $SQL_SERVER \
      --name $SQL_DATABASE \
      --service-objective S0

else
	echo "SQL database already exists: $SQL_SERVER"
fi