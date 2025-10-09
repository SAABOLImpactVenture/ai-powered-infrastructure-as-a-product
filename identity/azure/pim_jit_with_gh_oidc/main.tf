terraform {
  required_providers {
    azuread = { source = "hashicorp/azuread", version = ">= 2.49.0" }
    azapi   = { source = "azure/azapi", version = ">= 2.1.0" }
  }
}
provider "azuread" {}
provider "azapi" {}

variable "repo"     { type = string } # org/repo for GH OIDC
variable "envs"     { type = list(string) }
variable "role_def_id" { type = string } # e.g., Owner: 8e3af657-a8ff-443c-a75c-2fe8c4bcb635
variable "scope"    { type = string } # e.g., /subscriptions/000...

resource "azuread_application" "gha" { display_name = "gha-oidc-app" }
resource "azuread_service_principal" "gha" { client_id = azuread_application.gha.client_id }

resource "azuread_application_federated_identity_credential" "env" {
  for_each = toset(var.envs)
  application_object_id = azuread_application.gha.id
  display_name          = "gh-${each.value}"
  audiences             = ["api://AzureADTokenExchange"]
  issuer                = "https://token.actions.githubusercontent.com"
  subject               = "repo:${var.repo}:environment:${each.value}"
}

# Entra PIM JIT: Make the SP eligible (not permanent) for the role with approval required and 1h max
# Uses Microsoft Graph roleManagement API via azapi
resource "azapi_resource" "pim_eligibility" {
  type      = "microsoft.graph/roleManagement/directory/roleEligibilityScheduleRequests@2023-10-01-preview"
  name      = "gha-sp-eligibility"
  body = jsonencode({
    action   = "AdminAssign"
    justification = "Enable JIT via PIM for SP"
    scheduleInfo = {
      startDateTime = null
      expiration = { type = "afterDuration", duration = "PT0S" } # no expiry (eligibility stays until revoked)
    }
    principalId = azuread_service_principal.gha.object_id
    roleDefinitionId = var.role_def_id
    directoryScopeId = var.scope
    approvalSettings = {
      isApprovalRequired             = true
      isApprovalRequiredForExtension = true
      isRequestorJustificationRequired = true
      approvalMode                   = "SingleStage"
      approvers = [] # supply approvers via portal as needed
    }
  })
  response_export_values = ["id"]
}

output "entra_gha_app_client_id" { value = azuread_application.gha.client_id }
output "entra_pim_request_id"    { value = azapi_resource.pim_eligibility.output.id }
