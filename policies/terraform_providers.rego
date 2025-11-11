package terraform.providers

default deny = []

deny[msg] {
  input.resource_type == "terraform_provider"
  not input.values.version
  msg := "Terraform provider version pinning is required"
}

deny[msg] {
  input.resource_type == "terraform"
  not input.values.required_version
  msg := "Root terraform { required_version } must be pinned"
}
