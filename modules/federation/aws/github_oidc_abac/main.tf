terraform {
  required_providers { aws = { source="hashicorp/aws", version=">= 5.62" } }
}
provider "aws" { region = var.region }

variable "region" { type = string }
variable "repo"   { type = string }   # org/repo
variable "envs"   { type = list(string) }

resource "aws_iam_openid_connect_provider" "github" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}

locals {
  base_assume = {
    Version="2012-10-17",
    Statement=[{
      Effect="Allow",
      Action="sts:AssumeRoleWithWebIdentity",
      Principal={Federated=aws_iam_openid_connect_provider.github.arn},
      Condition={
        StringLike={ "token.actions.githubusercontent.com:sub": "repo:${var.repo}:*" },
        StringEquals={ "token.actions.githubusercontent.com:aud": "sts.amazonaws.com" }
      }
    }]
  }
}

# Create one env role each with ABAC: require session tag 'env' to match role name
resource "aws_iam_role" "gha" {
  for_each = toset(var.envs)
  name = "gha-${each.value}"
  assume_role_policy = jsonencode(local.base_assume)
  max_session_duration = 3600
  permissions_boundary = null
  inline_policy {
    name = "abac-env"
    policy = jsonencode({
      Version="2012-10-17",
      Statement=[{
        Effect="Allow",
        Action=["ec2:Describe*","s3:ListAllMyBuckets"],
        Resource="*",
        Condition = { StringEquals = { "aws:PrincipalTag/env": each.value } }
      }]
    })
  }
}

# Allow session tags to carry 'env'
resource "aws_iam_role_policy" "tag_session" {
  for_each = aws_iam_role.gha
  name = "tag-session"
  role = each.value.id
  policy = jsonencode({
    Version="2012-10-17",
    Statement=[{
      Effect="Allow",
      Action=["sts:TagSession"],
      Resource=each.value.arn,
      Condition={ StringEquals={ "aws:TagKeys": ["env"] } }
    }]
  })
}
output "role_arns" { value = { for k,v in aws_iam_role.gha : k => v.arn } }
