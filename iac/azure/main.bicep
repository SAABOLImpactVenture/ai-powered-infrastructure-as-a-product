param workspaceName string
param location string = resourceGroup().location
param dcrName string = 'iaap-dcr'
@description('Optional list of resource IDs (e.g., Arc servers) to associate with the DCR')
param associations array = []

resource la 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
  name: workspaceName
  location: location
  properties: {
    sku: { name: 'PerGB2018' }
    retentionInDays: 30
    features: {
      enableLogAccessUsingOnlyResourcePermissions: true
    }
  }
}

resource dcr 'Microsoft.Insights/dataCollectionRules@2022-06-01' = {
  name: dcrName
  location: location
  properties: {
    destinations: {
      logAnalytics: [
        {
          name: 'la-dest'
          workspaceResourceId: la.id
        }
      ]
    }
    dataFlows: [
      {
        streams: [
          'Custom-IAAP_InfraEvidence'
          'Custom-IAAP_AOAIRequests'
        ]
        destinations: [ 'la-dest' ]
      }
    ]
    dataSources: {
      customLogs: [
        {
          name: 'iaapInfraEvidenceSource'
          streams: [ 'Custom-IAAP_InfraEvidence' ]
          customLog: {
            logPaths: []
            # Using JSON lines via ingestion-time API or agent (future)
            # Here we set a sample record delimiter; upstream sender defines the table name suffix _CL
            recordDelimiter: '\n'
            filePatterns: []
          }
        }
        {
          name: 'iaapAoaiSource'
          streams: [ 'Custom-IAAP_AOAIRequests' ]
          customLog: {
            logPaths: []
            recordDelimiter: '\n'
            filePatterns: []
          }
        }
      ]
    }
  }
}

resource assoc 'Microsoft.Insights/dataCollectionRuleAssociations@2022-06-01' = [for id in associations: {
  name: 'assoc-${last(split(id, '/'))}-${dcr.name}'
  scope: resource(id, '2022-06-01')
  properties: {
    dataCollectionRuleId: dcr.id
    description: 'IaaP association'
  }
}]

output workspaceId string = la.properties.customerId
output workspaceResourceId string = la.id
output dcrResourceId string = dcr.id
