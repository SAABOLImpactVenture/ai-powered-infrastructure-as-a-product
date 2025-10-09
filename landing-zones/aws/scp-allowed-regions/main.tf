terraform {
  required_providers { aws = { source = "hashicorp/aws", version = ">= 5.62" } }
}
provider "aws" {}
variable "org_id" { type = string }
variable "allowed" { type = list(string) }

resource "aws_organizations_policy" "deny_regions" {
  name = "Deny-Unapproved-Regions"
  type = "SERVICE_CONTROL_POLICY"
  content = jsonencode({
    Version="2012-10-17",
    Statement=[{
      Sid="DenyOutsideAllowedRegions",Effect="Deny",Action="*",Resource="*",
      Condition={"StringNotEquals":{"aws:RequestedRegion": var.allowed}}
    }]
  })
}
