terraform {
  required_providers { oci = { source="oracle/oci", version=">= 6.7.0" } }
}
provider "oci" {}

variable "compartment_ocid" { type=string }
variable "tag_namespace" { type=string, default="platform" }
variable "tag_key" { type=string, default="env" }
variable "envs" { type = list(string) }

resource "oci_identity_tag_namespace" "ns" {
  compartment_id = var.compartment_ocid
  name = var.tag_namespace
  description = "ABAC tags"
}
resource "oci_identity_tag" "env" {
  tag_namespace_id = oci_identity_tag_namespace.ns.id
  name = var.tag_key
  description = "Environment tag"
}
resource "oci_identity_dynamic_group" "dg" {
  for_each = toset(var.envs)
  compartment_id = var.compartment_ocid
  name = "dg-${each.value}"
  matching_rule = "ANY { request.principal.tag.${var.tag_namespace}.${var.tag_key} == '${each.value}' }"
  description = "DG for env ${each.value}"
}
resource "oci_identity_policy" "policy" {
  for_each = oci_identity_dynamic_group.dg
  compartment_id = var.compartment_ocid
  name = "allow-env-${each.key}"
  statements = [
    "Allow dynamic-group ${each.value.name} to read all-resources in compartment id ${var.compartment_ocid}"
  ]
}
