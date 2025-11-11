targetScope = 'subscription'

@description('Policy definition IDs (from definitions deployment outputs)')
param requireTagsDefinitionId string
param allowedLocationsDefinitionId string

@description('Subscription scope to assign at (default: current subscription).')
@allowed([ subscription().id ])
param assignmentScope string = subscription().id

@description('Allowed locations list')
param allowedLocations array = [ 'eastus', 'eastus2' ]

@description('Required tags list')
param requiredTags array = [ 'owner', 'env', 'cost-center' ]

// Assignment: Require Tags (Audit)
resource requireTagsAssignment 'Microsoft.Authorization/policyAssignments@2022-06-01' = {
  name: 'require-tags-assignment'
  properties: {
    displayName: 'Audit required tags (IAAP Baseline)'
    scope: assignmentScope
    policyDefinitionId: requireTagsDefinitionId
    parameters: {
      requiredTags: { value: requiredTags }
    }
    enforcementMode: 'Default'
  }
}

// Assignment: Allowed Locations (Deny)
resource allowedLocationsAssignment 'Microsoft.Authorization/policyAssignments@2022-06-01' = {
  name: 'allowed-locations-assignment'
  properties: {
    displayName: 'Allowed locations (IAAP Baseline)'
    scope: assignmentScope
    policyDefinitionId: allowedLocationsDefinitionId
    parameters: {
      listOfAllowedLocations: { value: allowedLocations }
    }
    enforcementMode: 'Default'
  }
}
