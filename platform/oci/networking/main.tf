
terraform {
  required_providers { oci = { source = "oracle/oci", version = ">= 6.0" } }
}
provider "oci" {}
variable "compartment_ocid" { type = string }
resource "oci_core_vcn" "vcn" { cidr_block = "10.30.0.0/16" compartment_id = var.compartment_ocid display_name = "vcn-main" }
output "vcn_id" { value = oci_core_vcn.vcn.id }
