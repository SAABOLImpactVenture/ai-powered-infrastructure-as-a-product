terraform {
  required_version = ">= 1.8, < 2.0"
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 6.11"
    }
  }
}

provider "oci" {}

variable "tenancy_ocid" {
  type        = string
  description = "OCI tenancy OCID."
}

variable "compartment_ocid" {
  type        = string
  description = "Target compartment OCID for deployments."
}

resource "oci_identity_dynamic_group" "ci_workloads" {
  compartment_id = var.tenancy_ocid
  name           = "ci_workloads"
  description    = "CI/CD and OKE workload principals operating in the target compartment"
  matching_rule  = "All {request.principal.type = 'workload', target.compartment.id = '${var.compartment_ocid}'}"
}

resource "oci_identity_policy" "ci_policy" {
  compartment_id = var.compartment_ocid
  name           = "ci_compartment_policy"
  description    = "Permit CI and workloads to manage necessary resources within the compartment"
  statements = [
    "Allow dynamic-group ${oci_identity_dynamic_group.ci_workloads.name} to manage instance-family in compartment id ${var.compartment_ocid}",
    "Allow dynamic-group ${oci_identity_dynamic_group.ci_workloads.name} to manage cluster-family in compartment id ${var.compartment_ocid}",
    "Allow dynamic-group ${oci_identity_dynamic_group.ci_workloads.name} to manage load-balancers in compartment id ${var.compartment_ocid}",
    "Allow dynamic-group ${oci_identity_dynamic_group.ci_workloads.name} to read vaults in compartment id ${var.compartment_ocid}",
    "Allow dynamic-group ${oci_identity_dynamic_group.ci_workloads.name} to manage object-family in compartment id ${var.compartment_ocid}",
    "Allow dynamic-group ${oci_identity_dynamic_group.ci_workloads.name} to manage repos in compartment id ${var.compartment_ocid}"
  ]
}
