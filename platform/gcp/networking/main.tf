
terraform {
  required_providers { google = { source = "hashicorp/google", version = ">= 5.0" } }
}
provider "google" { project = var.project_id region = var.region }
variable "project_id" { type = string }
variable "region" { type = string }
resource "google_compute_network" "vpc" { name = "vpc-main" auto_create_subnetworks = false }
output "network" { value = google_compute_network.vpc.name }
