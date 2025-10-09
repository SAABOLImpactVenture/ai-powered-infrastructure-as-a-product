
terraform {
  required_providers { aws = { source = "hashicorp/aws", version = ">= 5.0" } }
}
provider "aws" { region = var.region }

variable "region" { type = string }
variable "name" { type = string }

resource "aws_vpc" "this" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = { Name = "${var.name}-vpc" }
}

output "vpc_id" { value = aws_vpc.this.id }
