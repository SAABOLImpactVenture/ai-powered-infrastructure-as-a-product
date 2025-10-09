
terraform {
  required_version = ">= 1.4.0"
}

variable "name" {
  type = string
  default = "golden-demo"
}

# This module creates only in-memory plan output (for demo). No null_resource or local-exec.
output "demo_plan_message" {
  value = "Plan for ${var.name} computed successfully."
}
