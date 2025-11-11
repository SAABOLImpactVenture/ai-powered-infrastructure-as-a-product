variable "location" { type = string, default = "eastus" }
variable "resource_group_name" { type = string }
variable "vnet_name" { type = string }
variable "address_space" { type = list(string), default = ["10.70.0.0/16"] }
variable "subnets" { type = map(string), default = { app = "10.70.1.0/24", data = "10.70.2.0/24" } }
variable "tags" { type = map(string), default = { owner = "platform-team", env = "dev", cost-center = "platform" } }
