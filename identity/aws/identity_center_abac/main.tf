terraform {
  required_providers { aws = { source = "hashicorp/aws", version = ">= 5.62" } }
}
provider "aws" { region = var.region }

variable "region"   { type = string }
variable "sso_instance_arn" { type = string } # data source can discover
variable "account_id" { type = string }
variable "envs"     { type = list(string) }

data "aws_ssoadmin_instances" "all" {}
locals { instance_arn = coalesce(var.sso_instance_arn, try(data.aws_ssoadmin_instances.all.arns[0], "")) }

resource "aws_ssoadmin_permission_set" "ps" {
  for_each = toset(var.envs)
  name        = "LeastPriv-${each.value}"
  instance_arn = local.instance_arn
  session_duration = "PT1H"
  relay_state      = "https://console.aws.amazon.com/"
  inline_policy    = jsonencode({
    Version="2012-10-17",
    Statement=[{
      Effect="Allow",
      Action=["ec2:Describe*","s3:ListAllMyBuckets"],
      Resource="*",
      Condition={ StringEquals={ "aws:PrincipalTag/env": each.value } }
    }]
  })
}

# Example assignment target: a placeholder group id (from external IdP via Identity Center). Provide real principal_id.
# resource "aws_ssoadmin_account_assignment" "assign" { ... }

output "permission_sets" { value = { for k,v in aws_ssoadmin_permission_set.ps : k => v.arn } }
