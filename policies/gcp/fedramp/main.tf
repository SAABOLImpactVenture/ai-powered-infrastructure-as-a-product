
terraform {
  required_providers { google = { source = "hashicorp/google", version = ">= 5.0" } }
}

provider "google" { project = var.project_id }

variable "project_id" { type = string }

# Enable Security Command Center
resource "google_scc_project_custom_module" "placeholder" {
  # This resource requires module definitions; as a baseline, enable SCC services via API separately.
  # Using google_security_center_service is not yet in provider; fallback via google_project_service:
  lifecycle { prevent_destroy = false }
}

resource "google_project_service" "services" {
  for_each = toset([
    "securitycenter.googleapis.com",
    "logging.googleapis.com",
    "monitoring.googleapis.com",
    "cloudkms.googleapis.com",
  ])
  project = var.project_id
  service = each.value
  disable_on_destroy = false
}

# Org Policies at project level
resource "google_org_policy_policy" "disable_serial" {
  name   = "projects/${var.project_id}/policies/compute.disableSerialPortAccess"
  parent = "projects/${var.project_id}"
  spec { rules { enforce = true } }
}

resource "google_org_policy_policy" "vm_external_ip" {
  name   = "projects/${var.project_id}/policies/compute.vmExternalIpAccess"
  parent = "projects/${var.project_id}"
  spec { rules { deny_all = true } }
}

# CMEK requirement for Cloud Storage
resource "google_org_policy_policy" "require_cmek_bq" {
  name   = "projects/${var.project_id}/policies/storagetransfer.requireEncryption"
  parent = "projects/${var.project_id}"
  spec { rules { enforce = true } }
}
