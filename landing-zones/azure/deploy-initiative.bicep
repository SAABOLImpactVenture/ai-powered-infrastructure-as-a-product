targetScope = 'subscription'

@description('Subscription ID to target for assignment.')
param targetSubscriptionId string

@description('Log Analytics workspace resource ID for diagnostics.')
param logAnalyticsId string

// Policy Definitions
resource denyPublicIp 'Microsoft.Authorization/policyDefinitions@2021-06-01' = {
  name: 'deny-public-ip'
  properties: json(loadTextContent('../../policies/azure/definitions/deny-public-ip.json')).properties
}

resource deployDiagnostics 'Microsoft.Authorization/policyDefinitions@2021-06-01' = {
  name: 'deploy-diagnostics'
  properties: json(loadTextContent('../../policies/azure/definitions/deploy-diagnostics.json')).properties
}

// Initiative
resource iaapBaseline 'Microsoft.Authorization/policySetDefinitions@2021-06-01' = {
  name: 'iaap-baseline'
  properties: {
    displayName: 'IAAP Baseline (Deny Public IP + Deploy Diagnostics)'
    description: 'A baseline initiative for network hardening and diagnostics.'
    metadata: {
      category: 'IAAP'
      version: '1.0.0'
    }
    parameters: {
      logAnalyticsId: {
        type: 'String'
        metadata: {
          displayName: 'Log Analytics Workspace Resource ID'
        }
      }
    }
    policyDefinitions: [
      {
        policyDefinitionReferenceId: 'deny-public-ip-ref'
        policyDefinitionId: denyPublicIp.id
      }
      {
        policyDefinitionReferenceId: 'deploy-diagnostics-ref'
        policyDefinitionId: deployDiagnostics.id
        parameters: {
          logAnalyticsId: {
            value: '[parameters(''logAnalyticsId'')]'
          }
        }
      }
    ]
  }
}

// Assignment
resource assignBaseline 'Microsoft.Authorization/policyAssignments@2022-06-01' = {
  name: 'iaap-baseline-assignment'
  properties: {
    displayName: 'IAAP Baseline Assignment'
    scope: subscriptionResourceId(targetSubscriptionId, '')
    policyDefinitionId: iaapBaseline.id
    enforcementMode: 'Default'
    parameters: {
      logAnalyticsId: {
        value: logAnalyticsId
      }
    }
  }
}
