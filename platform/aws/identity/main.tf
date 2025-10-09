
terraform {
  required_providers { aws = { source = "hashicorp/aws", version = ">= 5.0" } }
}
provider "aws" { region = var.region }
variable "region" { type = string }
variable "github_org" { type = string }
variable "repo" { type = string }
variable "account_id" { type = string }
data "aws_iam_policy_document" "assume_oidc" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals { type = "Federated", identifiers = ["arn:aws:iam::${var.account_id}:oidc-provider/token.actions.githubusercontent.com"] }
    condition { test = "StringLike", variable = "token.actions.githubusercontent.com:sub", values = ["repo:${var.github_org}/${var.repo}:*"] }
    condition { test = "StringEquals", variable = "token.actions.githubusercontent.com:aud", values = ["sts.amazonaws.com"] }
  }
}
resource "aws_iam_role" "github_oidc" { name = "github-oidc-ci" assume_role_policy = data.aws_iam_policy_document.assume_oidc.json }
output "role_arn" { value = aws_iam_role.github_oidc.arn }
