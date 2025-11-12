terraform {
  required_version = ">= 1.8, < 2.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.60"
    }
  }
}

provider "aws" {
  region = var.region
}

variable "region" {
  type        = string
  description = "AWS region for resources."
  default     = "us-east-1"
}

data "aws_caller_identity" "current" {}

resource "aws_iam_openid_connect_provider" "github" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["6938ef0d7c1e5e0bcd1f0c9b8f0f38d4e7f0e5f3"]
}

data "aws_iam_policy_document" "actions_assume_role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"
    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }
    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }
    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = [
        "repo:SAABOLImpactVenture/ai-powered-infrastructure-as-a-product:*"
      ]
    }
  }
}

resource "aws_iam_role" "github_deploy" {
  name               = "GitHubActionsDeployRole"
  assume_role_policy = data.aws_iam_policy_document.actions_assume_role.json
  tags = {
    Program     = "AI-PIaP"
    System      = "Platform"
    Environment = "Prod"
    Data-Class  = "Internal"
  }
}

data "aws_iam_policy_document" "deploy_policy" {
  statement {
    sid    = "InfrastructureDeployment"
    effect = "Allow"
    actions = [
      "cloudformation:*",
      "iam:PassRole",
      "ecr:*",
      "eks:*",
      "ec2:*",
      "ssm:*",
      "logs:*",
      "kms:DescribeKey",
      "kms:ListAliases",
      "kms:ListKeys",
      "s3:*"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "deploy_policy" {
  name        = "GitHubActionsDeploymentPolicy"
  description = "Broad but auditable permissions for CI-driven deployments."
  policy      = data.aws_iam_policy_document.deploy_policy.json
}

resource "aws_iam_role_policy_attachment" "attach" {
  role       = aws_iam_role.github_deploy.name
  policy_arn = aws_iam_policy.deploy_policy.arn
}
