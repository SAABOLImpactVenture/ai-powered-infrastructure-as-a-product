
param location string
param policyAssignmentName string = 'fedramp-baseline'
param logAnalyticsId string
param workspaceRegion string

@description('Assign built-in policies: encryption at rest, secure transfer, diagnostic settings to LA, Defender enablement.')
resource policy 'Microsoft.Authorization/policyAssignments@2021-06-01' = {
  name: policyAssignmentName
  properties: {
    displayName: 'FedRAMP Baseline Assignment'
    description: 'Core controls: encryption, logging, defender'
    policyDefinitionId: '/providers/Microsoft.Authorization/policySetDefinitions/06f7c4e4-0c4a-4bdd-9e64-3b5045c7fe64' // Azure Security Benchmark or substitute with custom set
    parameters: {}
    scope: subscription().id
    enforcementMode: 'Default'
  }
}

@description('Enable diagnostic settings for key resource types to Log Analytics')
resource diagRg 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: 'send-to-la-rg'
  scope: resourceGroup()
  properties: {
    workspaceId: logAnalyticsId
    logs: [
      { category: 'Administrative', enabled: true }
      { category: 'Security', enabled: true }
      { category: 'ServiceHealth', enabled: true }
      { category: 'Alert', enabled: true }
      { category: 'Recommendation', enabled: true }
      { category: 'Policy', enabled: true }
    ]
    metrics: [
      { category: 'AllMetrics', enabled: true }
    ]
  }
}
