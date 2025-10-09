terraform {
  required_providers { oci = { source="oracle/oci", version=">= 6.7.0" } }
}
provider "oci" {}
# Sample: Service Gateway + NAT Gateway pattern
