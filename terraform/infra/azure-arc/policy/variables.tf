variable "subscription_id" { type = string }
variable "resource_group_name" { type = string }
variable "connected_cluster_name" { type = string }
variable "policy_assignment_name" { type = string }
variable "policy_definition_id" {
  type = string
  description = "Azure Policy (initiative or definition) ID to assign at the connected cluster scope"
}
variable "location" { type = string }
variable "tags" { type = map(string) default = {} }
