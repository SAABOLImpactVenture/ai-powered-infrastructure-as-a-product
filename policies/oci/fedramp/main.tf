
terraform {
  required_providers { oci = { source = "oracle/oci", version = ">= 6.0" } }
}

provider "oci" {}

variable "compartment_ocid" { type = string }
variable "target_name" { type = string }

# Enable Cloud Guard with a responder recipe and target
resource "oci_cloud_guard_target" "target" {
  compartment_id = var.compartment_ocid
  display_name   = var.target_name
  target_resource_type = "COMPARTMENT"
  target_resource_id   = var.compartment_ocid
}

# Logging policy: deny public bucket/object access (defense in depth)
resource "oci_identity_policy" "deny_public" {
  compartment_id = var.compartment_ocid
  name           = "${var.target_name}-deny-public"
  description    = "Baseline deny statements to avoid public access."
  statements = [
    "deny any-user to read buckets in compartment id ${var.compartment_ocid} where all {request.principal.type = 'any-user'}",
    "deny any-user to read objects in compartment id ${var.compartment_ocid} where all {request.principal.type = 'any-user'}"
  ]
}
