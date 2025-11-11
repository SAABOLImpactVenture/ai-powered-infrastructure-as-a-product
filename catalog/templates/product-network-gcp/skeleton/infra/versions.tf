terraform {
  required_version = ">= 1.8.0, < 2.0.0"
  required_providers {
    google = { source = "hashicorp/google", version = "~> 5.40" }
  }
}
provider "google" {
  project = var.project
  region  = var.region
}
