terraform {
  required_providers { oci = { source = "oracle/oci", version = ">= 6.7.0" } }
}
provider "oci" {}

variable "compartment_ocid" { type = string }
variable "idp_name" { type = string }
variable "metadata"  { description = "SAML metadata XML" type = string }

resource "oci_identity_identity_provider" "saml" {
  compartment_id = var.compartment_ocid
  name           = var.idp_name
  description    = "External SAML IdP (e.g., Entra ID)"
  product_type   = "IDCS"
  protocol       = "SAML2"
  metadata       = var.metadata
}

# Example policy: allow group to manage a compartment
resource "oci_identity_group" "devops" {
  compartment_id = var.compartment_ocid
  name = "devops"
  description = "DevOps group (federated)"
}

resource "oci_identity_policy" "compartment_policy" {
  compartment_id = var.compartment_ocid
  name = "devops-compartment-policy"
  statements = [
    "Allow group devops to read all-resources in compartment id ${var.compartment_ocid}"
  ]
  description = "Least privilege sample"
}
