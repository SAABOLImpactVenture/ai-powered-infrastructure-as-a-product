terraform {
  required_providers { aws = { source="hashicorp/aws", version=">= 5.62" } }
}
provider "aws" { region = var.region }

variable "region"     { type = string }
variable "repo"       { type = string }           # org/repo
variable "envs"       { type = list(string) }     # ["dev","test","prod"]
variable "data_class" { type = string }           # e.g., "cui", "internal"
variable "workload"   { type = string }           # e.g., "payments"

resource "aws_iam_openid_connect_provider" "github" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}

resource "aws_iam_role" "gha_env" {
  for_each = toset(var.envs)
  name = "gha-${each.value}-${var.workload}"
  assume_role_policy = jsonencode({
    Version="2012-10-17",
    Statement=[{
      Effect="Allow", Action="sts:AssumeRoleWithWebIdentity",
      Principal={ Federated=aws_iam_openid_connect_provider.github.arn },
      Condition={
        StringLike = { "token.actions.githubusercontent.com:sub": "repo:${var.repo}:environment:${each.value}" },
        StringEquals = { "token.actions.githubusercontent.com:aud": "sts.amazonaws.com" }
      }
    }]
  })
  max_session_duration = 3600
  tags = { env = each.value, data_class = var.data_class, workload = var.workload }
}

# ABAC: Only allow actions when session tags match env/data_class/workload
resource "aws_iam_role_policy" "abac" {
  for_each = aws_iam_role.gha_env
  name = "abac-conditions"
  role = each.value.id
  policy = jsonencode({
    Version="2012-10-17",
    Statement=[{
      Effect="Allow",
      Action=["ec2:Describe*","s3:ListAllMyBuckets"],
      Resource="*",
      Condition={
        StringEquals={
          "aws:PrincipalTag/env": each.key,
          "aws:PrincipalTag/data_class": "${var.data_class}",
          "aws:PrincipalTag/workload": "${var.workload}"
        }
      }
    }]
  })
}

# Allow tagging session
resource "aws_iam_role_policy" "tag_session" {
  for_each = aws_iam_role.gha_env
  name = "tag-session"
  role = each.value.id
  policy = jsonencode({
    Version="2012-10-17",
    Statement=[{
      Effect="Allow", Action=["sts:TagSession"], Resource=each.value.arn,
      Condition={ StringEquals={ "aws:TagKeys": ["env","data_class","workload"] } }
    }]
  })
}

output "role_arns" { value = { for k,v in aws_iam_role.gha_env : k => v.arn } }
