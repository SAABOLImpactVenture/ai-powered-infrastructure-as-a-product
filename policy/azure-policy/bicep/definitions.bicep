targetScope = 'subscription'

@description('Display name suffix for custom policies')
param displayNameSuffix string = 'IAAP Baseline'

// Require Tags (Audit)
resource requireTags 'Microsoft.Authorization/policyDefinitions@2021-06-01' = {
  name: 'require-tags'
  properties: {
    policyType: 'Custom'
    mode: 'Indexed'
    displayName: 'Audit required tags (${displayNameSuffix})'
    description: 'Audits resources missing required tags: owner, env, cost-center'
    metadata: { category: 'Tags' }
    parameters: {
      requiredTags: {
        type: 'Array'
        metadata: { displayName: 'Required tags' }
        defaultValue: [ 'owner', 'env', 'cost-center' ]
      }
    }
    policyRule: {
      if: {
        anyOf: [
          { not: { field: "tags['owner']",       exists: true } }
          { not: { field: "tags['env']",         exists: true } }
          { not: { field: "tags['cost-center']", exists: true } }
        ]
      }
      then: { effect: 'Audit' }
    }
  }
}

// Allowed Locations (Deny)
resource allowedLocations 'Microsoft.Authorization/policyDefinitions@2021-06-01' = {
  name: 'allowed-locations'
  properties: {
    policyType: 'Custom'
    mode: 'Indexed'
    displayName: 'Allowed locations (${displayNameSuffix})'
    description: 'Deny resources not in approved locations.'
    metadata: { category: 'General' }
    parameters: {
      listOfAllowedLocations: {
        type: 'Array'
        metadata: { displayName: 'Allowed locations' }
        defaultValue: [ 'eastus', 'eastus2' ]
      }
    }
    policyRule: {
      if: {
        not: {
          field: 'location'
          in: "[parameters('listOfAllowedLocations')]"
        }
      }
      then: { effect: 'Deny' }
    }
  }
}

output requireTagsId string = requireTags.id
output allowedLocationsId string = allowedLocations.id
