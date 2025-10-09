terraform {
  required_providers { aws = { source="hashicorp/aws", version=">= 5.62" } }
}
provider "aws" { region = var.region }
variable "region" { type=string }
variable "amount" { type=number }
resource "aws_budgets_budget" "monthly" {
  name = "PlatformMonthly"
  budget_type = "COST"
  limit_amount = tostring(var.amount)
  limit_unit   = "USD"
  time_unit    = "MONTHLY"
  notification {
    comparison_operator = "GREATER_THAN"
    threshold           = 80
    threshold_type      = "PERCENTAGE"
    notification_type   = "ACTUAL"
    subscriber_email_addresses = ["finops@example.com"]
  }
}
