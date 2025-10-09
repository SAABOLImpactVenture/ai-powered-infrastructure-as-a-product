terraform {
  required_providers { google = { source="hashicorp/google", version=">= 5.40" } }
}
provider "google" { project = var.project_id }
variable "project_id" { type=string }

resource "google_org_policy_policy" "bucket_cmek" {
  name   = "projects/${var.project_id}/policies/storage.uniformBucketLevelAccess"
  parent = "projects/${var.project_id}"
  spec { rules { enforce = true } }
}
