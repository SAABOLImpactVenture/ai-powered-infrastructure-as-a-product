terraform {
  required_providers { google = { source = "hashicorp/google", version = ">= 5.40" } }
}
provider "google" { project = var.project_id }
variable "project_id" { type = string }

resource "google_org_policy_policy" "sql_public_ips" {
  name   = "projects/${var.project_id}/policies/sql.restrictPublicIp"
  parent = "projects/${var.project_id}"
  spec {
    rules { deny_all = true }
  }
}
