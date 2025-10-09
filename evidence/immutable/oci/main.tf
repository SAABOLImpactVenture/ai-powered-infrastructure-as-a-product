terraform {
  required_providers { oci = { source = "oracle/oci", version = ">= 6.0" } }
}
provider "oci" {}
variable "compartment_ocid" { type = string }
variable "namespace" { type = string }
variable "bucket_name" { type = string }
variable "retention_days" { type = number, default = 90 }

resource "oci_objectstorage_bucket" "evidence" {
  compartment_id = var.compartment_ocid
  name           = var.bucket_name
  namespace      = var.namespace
  object_events_enabled = false
  storage_tier = "Standard"
  versioning = "Enabled"
  kms_key_id = null
  auto_tiering = "Disabled"
  access_type = "NoPublicAccess"
}

resource "oci_objectstorage_retention_rule" "retention" {
  bucket    = oci_objectstorage_bucket.evidence.name
  namespace = var.namespace
  display_name = "evidence-retention"
  time_rule_locked = null
  duration {
    time_amount = var.retention_days
    time_unit = "DAYS"
  }
}
output "bucket" { value = oci_objectstorage_bucket.evidence.name }
