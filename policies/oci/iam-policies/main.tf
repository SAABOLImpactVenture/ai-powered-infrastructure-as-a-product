
terraform {
  required_providers { oci = { source = "oracle/oci", version = ">= 6.0" } }
}
provider "oci" {}

variable "compartment_ocid" { type = string }
variable "name"             { type = string }

# Example IAM policy to block object reads from public internet (requires proper conditions)
resource "oci_identity_policy" "deny_public_buckets" {
  compartment_id = var.compartment_ocid
  name           = var.name
  description    = "Baseline IAM policy to restrict public access patterns."
  statements = [
    "deny any-user to read buckets in compartment id ${var.compartment_ocid} where all {request.principal.type = 'any-user'}",
    "deny any-user to read objects in compartment id ${var.compartment_ocid} where all {request.principal.type = 'any-user'}"
  ]
}
