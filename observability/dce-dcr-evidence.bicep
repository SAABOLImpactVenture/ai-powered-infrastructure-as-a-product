
param location string
param workspaceId string
param dceName string = 'evidence-dce'
param dcrName string = 'evidence-dcr'
param tableName string = 'Evidence_CL'

resource dce 'Microsoft.Insights/dataCollectionEndpoints@2022-06-01' = {
  name: dceName
  location: location
  properties: {}
}

resource dcr 'Microsoft.Insights/dataCollectionRules@2022-06-01' = {
  name: dcrName
  location: location
  properties: {
    dataSources: {
      customLogs: [
        {
          name: 'evidence-json'
          streams: [ 'Custom-Logs' ]
          fileLogs: {
            filePatterns: [ '/var/mcp/evidence/*/*.json' ]
            format: { json: { mappingMode: 'Common' } }
          }
        }
      ]
    }
    destinations: {
      logAnalytics: [
        {
          name: 'la'
          workspaceResourceId: workspaceId
        }
      ]
    }
    dataFlows: [
      {
        streams: [ 'Custom-Logs' ]
        destinations: [ 'la' ]
      }
    ]
  }
}
