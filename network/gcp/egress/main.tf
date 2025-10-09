terraform {
  required_providers { google = { source="hashicorp/google", version=">= 5.40" } }
}
provider "google" { project = var.project_id }
# Sample: Cloud NAT + Private Service Connect for Google APIs
