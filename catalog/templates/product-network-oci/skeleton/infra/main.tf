resource "oci_core_vcn" "vcn" {
  cidr_block     = var.vcn_cidr
  compartment_id = var.compartment_ocid
  display_name   = var.display_name
}
resource "oci_core_subnet" "subnet" {
  cidr_block                   = "10.100.1.0/24"
  compartment_id               = var.compartment_ocid
  vcn_id                       = oci_core_vcn.vcn.id
  display_name                 = "${var.display_name}-subnet"
  prohibit_public_ip_on_vnic   = true
}
