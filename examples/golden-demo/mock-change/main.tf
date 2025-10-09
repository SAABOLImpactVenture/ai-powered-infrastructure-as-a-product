terraform {
  required_version = ">= 1.4.0"
}
variable "name" { type = string, default = "golden-demo" }
output "demo_plan_message" { value = "Plan for ${var.name} computed successfully." }
