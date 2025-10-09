terraform {
  required_providers { oci = { source="oracle/oci", version=">= 6.7.0" } }
}
provider "oci" {}

variable "compartment_ocid" { type=string }
variable "bucket_name" { type=string }
variable "kms_key_id"  { type=string }

resource "oci_objectstorage_bucket" "state" {
  compartment_id = var.compartment_ocid
  name = var.bucket_name
  storage_tier = "Standard"
  access_type  = "NoPublicAccess"
  versioning   = "Enabled"
  kms_key_id   = var.kms_key_id
  retention_rules = [{
    display_name = "immutability-30d"
    duration = { time_amount = 30, time_unit = "DAYS" }
    time_rule_locked = null
  }]
}

output "bucket" { value = oci_objectstorage_bucket.state.name }
