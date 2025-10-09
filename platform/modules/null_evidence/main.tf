
terraform {
  required_version = ">= 1.4.0"
}

locals {
  deprecation_notice = "This module is deprecated and excluded from the accelerator. Use modules under platform/<cloud>/*."
}

output "deprecation_notice" {
  value = local.deprecation_notice
}
