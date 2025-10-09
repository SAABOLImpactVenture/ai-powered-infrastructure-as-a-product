terraform {
  required_providers { oci = { source = "oracle/oci", version = ">= 6.7.0" } }
}
provider "oci" {}

variable "compartment_ocid" { type = string }

resource "oci_cloud_guard_cloud_guard_configuration" "cfg" {
  compartment_id = var.compartment_ocid
  reporting_region = "us-ashburn-1"
  status = "ENABLED"
}
