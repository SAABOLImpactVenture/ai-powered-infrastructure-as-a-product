terraform { required_providers { oci = { source="oracle/oci", version=">= 6.7.0" } } }
provider "oci" {}
variable "compartment_ocid" { type=string }
variable "amount" { type=number }
resource "oci_budget_budget" "budget" {
  compartment_id = var.compartment_ocid
  amount = var.amount
  reset_period = "MONTHLY"
  target_type = "COMPARTMENT"
}
