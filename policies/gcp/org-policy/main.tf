
terraform {
  required_providers { google = { source = "hashicorp/google", version = ">= 5.0" } }
}
provider "google" { project = var.project_id }

variable "project_id" { type = string }

# Disable serial port access
resource "google_org_policy_policy" "disable_serial_port" {
  name   = "projects/${var.project_id}/policies/compute.disableSerialPortAccess"
  parent = "projects/${var.project_id}"

  spec {
    rules {
      enforce = true
    }
  }
}

# Restrict external IPs on VMs
resource "google_org_policy_policy" "restrict_external_ip" {
  name   = "projects/${var.project_id}/policies/compute.vmExternalIpAccess"
  parent = "projects/${var.project_id}"
  spec {
    rules {
      deny_all = true
    }
  }
}
