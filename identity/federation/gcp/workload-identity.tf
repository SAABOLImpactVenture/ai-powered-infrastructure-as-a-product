terraform {
  required_version = ">= 1.8, < 2.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.39"
    }
  }
}

provider "google" {
  project = var.project_id
}

variable "project_id" {
  type        = string
  description = "GCP project ID."
}

resource "google_iam_workload_identity_pool" "github_pool" {
  workload_identity_pool_id = "github-actions-pool"
  display_name              = "GitHub Actions Pool"
  description               = "OIDC Federation for GitHub Actions"
}

resource "google_iam_workload_identity_pool_provider" "github_provider" {
  workload_identity_pool_id          = google_iam_workload_identity_pool.github_pool.workload_identity_pool_id
  workload_identity_pool_provider_id = "github-actions"
  display_name                       = "GitHub OIDC"
  description                        = "Provider for token.actions.githubusercontent.com"
  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }
  attribute_mappings = {
    "google.subject"           = "assertion.sub"
    "attribute.repository"     = "assertion.repository"
    "attribute.ref"            = "assertion.ref"
  }
}

resource "google_service_account" "ci" {
  account_id   = "github-actions-deployer"
  display_name = "GitHub Actions Deployer"
}

resource "google_service_account_iam_member" "bind" {
  service_account_id = google_service_account.ci.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/projects/${data.google_project.project.number}/locations/global/workloadIdentityPools/${google_iam_workload_identity_pool.github_pool.workload_identity_pool_id}/attribute.repository/SAABOLImpactVenture/ai-powered-infrastructure-as-a-product"
}

data "google_project" "project" {
  project_id = var.project_id
}
