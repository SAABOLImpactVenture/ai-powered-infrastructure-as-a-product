package terraform.network

default deny = []

# AWS: Ban 0.0.0.0/0 for SSH and RDP
deny[msg] {
  input.resource_type == "aws_security_group_rule"
  input.values.cidr_blocks[_] == "0.0.0.0/0"
  ports := { tostring(input.values.from_port), tostring(input.values.to_port) }
  some p
  p := "22"
  msg := "Prohibit SSH from 0.0.0.0/0"
}

deny[msg] {
  input.resource_type == "aws_security_group_rule"
  input.values.cidr_blocks[_] == "0.0.0.0/0"
  ports := { tostring(input.values.from_port), tostring(input.values.to_port) }
  some p
  p := "3389"
  msg := "Prohibit RDP from 0.0.0.0/0"
}

# Azure: wildcard NSG SSH/RDP
deny[msg] {
  input.resource_type == "azurerm_network_security_rule"
  input.values.source_address_prefix == "*"
  input.values.destination_port_range == "22"
  msg := "Prohibit SSH from any source in NSG rule"
}

deny[msg] {
  input.resource_type == "azurerm_network_security_rule"
  input.values.source_address_prefix == "*"
  input.values.destination_port_range == "3389"
  msg := "Prohibit RDP from any source in NSG rule"
}

# GCP: open firewall on 22/3389
deny[msg] {
  input.resource_type == "google_compute_firewall"
  input.values.source_ranges[_] == "0.0.0.0/0"
  input.values.allowed[_].ports[_] == "22"
  msg := "Prohibit SSH from 0.0.0.0/0 (GCP)"
}
deny[msg] {
  input.resource_type == "google_compute_firewall"
  input.values.source_ranges[_] == "0.0.0.0/0"
  input.values.allowed[_].ports[_] == "3389"
  msg := "Prohibit RDP from 0.0.0.0/0 (GCP)"
}
