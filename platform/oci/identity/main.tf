
terraform {
  required_providers { oci = { source = "oracle/oci", version = ">= 6.0" } }
}
provider "oci" {}
variable "compartment_ocid" { type = string }
variable "group_name" { type = string }
resource "oci_identity_dynamic_group" "dg" {
  compartment_id = var.compartment_ocid
  name = var.group_name
  description = "Dynamic group for CI"
  matching_rule = "any {all {resource.type = 'all-resources'}}"
}
output "dynamic_group_ocid" { value = oci_identity_dynamic_group.dg.id }
