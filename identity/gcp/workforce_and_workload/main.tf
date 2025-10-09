terraform {
  required_providers { google = { source = "hashicorp/google", version = ">= 5.40" } }
}
provider "google" { project = var.project_id }

variable "project_id" { type=string }
variable "workforce_pool_id" { type=string, default="entra" }
variable "issuer_uri" { type=string } # Azure Entra OIDC issuer
variable "repo" { type=string } # org/repo for workload federation

# Workforce (for humans)
resource "google_iam_workforce_pool" "pool" {
  workforce_pool_id = var.workforce_pool_id
  display_name = "Entra Workforce"
  parent = "organizations/${data.google_project.project.organization_id}"
}
data "google_project" "project" {}

resource "google_iam_workforce_pool_provider" "provider" {
  workforce_pool_id = google_iam_workforce_pool.pool.workforce_pool_id
  workforce_pool_provider_id = "entra"
  display_name = "Entra"
  oidc {
    issuer_uri = var.issuer_uri
  }
  attribute_mapping = {
    "google.subject" = "assertion.sub"
    "attribute.tid" = "assertion.tid"
    "attribute.upn" = "assertion.preferred_username"
  }
}

# Workload (CI from GitHub)
resource "google_iam_workload_identity_pool" "wif_pool" {
  workload_identity_pool_id = "github"
  display_name = "GitHub Actions"
}
resource "google_iam_workload_identity_pool_provider" "wif_provider" {
  workload_identity_pool_id = google_iam_workload_identity_pool.wif_pool.workload_identity_pool_id
  workload_identity_pool_provider_id = "oidc"
  display_name = "OIDC"
  oidc { issuer_uri = "https://token.actions.githubusercontent.com" }
  attribute_mapping = {
    "google.subject" = "assertion.sub"
    "attribute.repository" = "assertion.repository"
    "attribute.environment" = "assertion.environment"
  }
}
resource "google_service_account" "gha" { account_id="gha-actions" }
resource "google_service_account_iam_binding" "bind" {
  service_account_id = google_service_account.gha.name
  role = "roles/iam.workloadIdentityUser"
  members = [
    "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.wif_pool.name}/attribute.repository/${var.repo}"
  ]
}
output "workforce_pool_name" { value = google_iam_workforce_pool.pool.name }
output "workload_sa" { value = google_service_account.gha.email }
