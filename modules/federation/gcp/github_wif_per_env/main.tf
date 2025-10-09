terraform {
  required_providers { google = { source="hashicorp/google", version=">= 5.40" } }
}
provider "google" { project = var.project_id }

variable "project_id" { type=string }
variable "repo" { type=string }       # org/repo
variable "envs" { type=list(string) }

resource "google_iam_workload_identity_pool" "pool" {
  workload_identity_pool_id = "github"
  display_name = "GitHub Actions"
}
resource "google_iam_workload_identity_pool_provider" "prov" {
  workload_identity_pool_id = google_iam_workload_identity_pool.pool.workload_identity_pool_id
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
  members = concat([
    "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.pool.name}/attribute.repository/${var.repo}"
  ])
}
output "service_account" { value = google_service_account.gha.email }
