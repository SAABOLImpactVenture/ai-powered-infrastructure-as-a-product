@description('Storage account with immutable blob policy for evidence')
param location string
param name string
param rgName string
param retentionInDays int = 90

resource rg 'Microsoft.Resources/resourceGroups@2022-09-01' existing = {
  name: rgName
}

resource sa 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: name
  location: location
  sku: { name: 'Standard_GRS' }
  kind: 'StorageV2'
  properties: {
    allowBlobPublicAccess: false
    encryption: {
      services: { blob: { enabled: true } }
      keySource: 'Microsoft.Storage'
    }
    immutabilityPolicy: null
  }
}

resource container 'Microsoft.Storage/storageAccounts/blobServices/containers@2023-01-01' = {
  name: '${sa.name}/default/evidence'
  properties: {
    publicAccess: 'None'
    immutableStorageWithVersioning: {
      enabled: true
      immutabilityPolicy: {
        allowProtectedAppendWritesAll: true
        immutabilityPeriodSinceCreationInDays: retentionInDays
        state: 'Unlocked'
      }
    }
  }
}
