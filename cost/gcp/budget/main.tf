terraform {
  required_providers { google = { source="hashicorp/google", version=">= 5.40" } }
}
provider "google" { project = var.project_id }
variable "project_id" { type=string }
variable "amount" { type=number }
resource "google_billing_budget" "budget" {
  billing_account = var.billing_account
  amount { specified_amount { currency_code = "USD" units = tostring(var.amount) } }
  threshold_rules { threshold_percent = 0.8 }
}
