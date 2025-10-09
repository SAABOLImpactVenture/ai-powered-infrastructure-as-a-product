terraform {
  required_providers { google = { source = "hashicorp/google", version = ">= 5.0" } }
}
provider "google" { project = var.project_id }
variable "project_id" { type = string }
variable "bucket_name" { type = string }
variable "retention_days" { type = number, default = 90 }

resource "google_storage_bucket" "evidence" {
  name     = var.bucket_name
  location = "US"
  force_destroy = false
  versioning { enabled = true }
  retention_policy {
    retention_period = var.retention_days * 24 * 60 * 60
    is_locked = false
  }
  uniform_bucket_level_access = true
  encryption { default_kms_key_name = null }
}
output "bucket" { value = google_storage_bucket.evidence.name }
