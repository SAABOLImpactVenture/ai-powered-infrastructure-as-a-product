terraform {
  required_providers { oci = { source="oracle/oci", version=">= 6.7.0" } }
}
provider "oci" {}
variable "compartment_ocid" { type=string }
variable "amount" { type=number }
resource "oci_budget_budget" "budget" {
  compartment_id = var.compartment_ocid
  target_type = "COMPARTMENT"
  amount = var.amount
  reset_period = "MONTHLY"
  description = "Platform budget"
}
