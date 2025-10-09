terraform {
  required_providers { oci = { source="oracle/oci", version=">= 6.7.0" } }
}
provider "oci" {}

variable "tenancy_ocid" { type=string }

resource "oci_identity_compartment" "platform" {
  compartment_id = var.tenancy_ocid
  name = "platform"
  description = "Platform compartment"
}
