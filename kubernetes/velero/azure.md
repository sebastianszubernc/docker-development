# Run Azure CLI

```
docker run -it --rm --entrypoint /bin/bash mcr.microsoft.com/azure-cli:2.53.1
```

# Login to Azure

```
az login
```

# Create Storage

```
AZURE_BACKUP_RESOURCE_GROUP=seba-velero
AZURE_STORAGE_ACCOUNT_NAME=sebavelero1027
BLOB_CONTAINER=velero-control-plane
AZURE_BACKUP_SUBSCRIPTION_ID=866a781f-d26d-484d-baeb-1a4db562a93a

# set subscription
az account set --subscription $AZURE_BACKUP_SUBSCRIPTION_ID
# resource group
az group create -n $AZURE_BACKUP_RESOURCE_GROUP --location westeurope

# storage account
az storage account create \
    --name $AZURE_STORAGE_ACCOUNT_NAME \
    --resource-group $AZURE_BACKUP_RESOURCE_GROUP \
    --sku Standard_GRS \
    --allow-blob-public-access false \
    --https-only true

# get key
AZURE_STORAGE_ACCOUNT_ACCESS_KEY=`az storage account keys list --account-name $AZURE_STORAGE_ACCOUNT_NAME --query "[?keyName == 'key1'].value" -o tsv`

# blob container
az storage container create -n $BLOB_CONTAINER \
  --public-access off \
  --account-name $AZURE_STORAGE_ACCOUNT_NAME \
  --account-key $AZURE_STORAGE_ACCOUNT_ACCESS_KEY

```

# Export variables

Let's export these variables into our Velero container <br/>
<br/>
Copy and paste this to the velero container:
```

printf "export BLOB_CONTAINER=$BLOB_CONTAINER \nexport AZURE_BACKUP_RESOURCE_GROUP=$AZURE_BACKUP_RESOURCE_GROUP \nexport AZURE_STORAGE_ACCOUNT_NAME=$AZURE_STORAGE_ACCOUNT_NAME \nexport AZURE_STORAGE_ACCOUNT_ACCESS_KEY=$AZURE_STORAGE_ACCOUNT_ACCESS_KEY \nexport AZURE_BACKUP_SUBSCRIPTION_ID=$AZURE_BACKUP_SUBSCRIPTION_ID\n"
```