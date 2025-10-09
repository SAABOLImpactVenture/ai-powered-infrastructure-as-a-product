terraform {
  required_providers { google = { source="hashicorp/google", version=">= 5.40" } }
}
provider "google" {}

variable "org_id" { type=string }

resource "google_org_policy_policy" "disable_sa_keys" {
  name   = "organizations/${var.org_id}/policies/iam.disableServiceAccountKeyCreation"
  parent = "organizations/${var.org_id}"
  spec { rules { enforce = true } }
}
