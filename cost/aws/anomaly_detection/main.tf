terraform {
  required_providers { aws = { source="hashicorp/aws", version=">= 5.62" } }
}
provider "aws" { region = var.region }
variable "region" { type=string }
variable "email"  { type=string }

resource "aws_ce_anomaly_monitor" "total_spend" {
  name              = "TotalSpend"
  monitor_type      = "DIMENSIONAL"
  monitor_dimension = "SERVICE"
}
resource "aws_ce_anomaly_subscription" "notify" {
  name      = "NotifyFinOps"
  frequency = "DAILY"
  monitor_arn_list = [aws_ce_anomaly_monitor.total_spend.arn]
  subscribers {
    type  = "EMAIL"
    address = var.email
  }
  threshold_expression = jsonencode({ And: [ { DimensionValues: { Key: "ANOMALY_TOTAL_IMPACT_ABSOLUTE", MatchOptions: ["GREATER_THAN_OR_EQUAL"], Values: ["20"] } } ] })
}
