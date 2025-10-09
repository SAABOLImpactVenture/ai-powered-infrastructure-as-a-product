
terraform {
  required_providers { google = { source = "hashicorp/google", version = ">= 5.0" } }
}
provider "google" { project = var.project_id }
variable "project_id" { type = string }
variable "pool_id" { type = string }
variable "provider_id" { type = string }
resource "google_iam_workload_identity_pool" "pool" { workload_identity_pool_id = var.pool_id display_name = "github-pool" }
resource "google_iam_workload_identity_pool_provider" "provider" {
  workload_identity_pool_id = google_iam_workload_identity_pool.pool.workload_identity_pool_id
  workload_identity_pool_provider_id = var.provider_id
  display_name = "github-provider"
  oidc { issuer_uri = "https://token.actions.githubusercontent.com" }
}
output "provider_name" { value = google_iam_workload_identity_pool_provider.provider.name }
