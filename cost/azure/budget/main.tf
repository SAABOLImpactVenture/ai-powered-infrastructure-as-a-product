terraform {
  required_providers { azurerm = { source="hashicorp/azurerm", version=">= 3.115.0" } }
}
provider "azurerm" { features {} }
variable "scope" { type=string } # /subscriptions/<id>
variable "amount" { type=number }
resource "azurerm_consumption_budget_subscription" "budget" {
  name = "platform-budget"
  subscription_id = var.scope
  amount = var.amount
  time_grain = "Monthly"
  time_period { start_date = "2025-01-01T00:00:00Z" end_date = "2026-01-01T00:00:00Z" }
  notification {
    operator = "GreaterThan"
    threshold = 80
    contact_emails = ["finops@example.com"]
    threshold_type = "Actual"
  }
}
