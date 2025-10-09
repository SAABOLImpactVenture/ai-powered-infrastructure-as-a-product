terraform {
  required_providers { google = { source = "hashicorp/google", version = ">= 5.40" } }
}
provider "google" { project = var.project_id }
variable "project_id" { type = string }
variable "bucket_name" { type = string }

resource "google_storage_bucket" "state" {
  name                        = var.bucket_name
  location                    = "US"
  uniform_bucket_level_access = true
  versioning { enabled = true }
  retention_policy { retention_period = 60 * 60 * 24 * 30 } # 30 days
}
output "backend" {
  value = <<EOT
backend "gcs" {
  bucket = "${google_storage_bucket.state.name}"
  prefix = "tfstate"
}
EOT
}
