terraform {
  required_providers { aws = { source="hashicorp/aws", version=">= 5.62" } }
}
provider "aws" { region = var.region }
# Sample: NAT Gateway for IPv4 egress, Egress-only IGW for IPv6, VPC endpoints for S3/STS
