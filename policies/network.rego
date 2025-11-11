package terraform.network

deny[msg] {
  input.resource_type == "aws_security_group_rule"
  input.values.cidr_blocks[_] == "0.0.0.0/0"
  input.values.from_port <= 22
  input.values.to_port >= 22
  msg := "Prohibit SSH from 0.0.0.0/0"
}

deny[msg] {
  input.resource_type == "azurerm_network_security_rule"
  input.values.source_address_prefix == "*"
  input.values.destination_port_range == "22"
  msg := "Prohibit SSH from any source in NSG rule"
}

deny[msg] {
  input.resource_type == "google_compute_firewall"
  input.values.source_ranges[_] == "0.0.0.0/0"
  input.values.allowed[_].ports[_] == "22"
  msg := "Prohibit SSH from 0.0.0.0/0 (GCP)"
}
