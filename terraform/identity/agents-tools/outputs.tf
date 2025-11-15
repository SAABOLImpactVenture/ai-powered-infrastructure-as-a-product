output "tool_jira_client_id" {
  value = azuread_application.tool_jira.client_id
}

output "tool_jira_sp_object_id" {
  value     = azuread_service_principal.tool_jira.id
  sensitive = true
}
