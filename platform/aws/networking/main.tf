
terraform {
  required_providers { aws = { source = "hashicorp/aws", version = ">= 5.0" } }
}
provider "aws" { region = var.region }
variable "region" { type = string }
variable "name" { type = string }
resource "aws_vpc" "this" { cidr_block = "10.20.0.0/16" tags = { Name = var.name } }
output "vpc_id" { value = aws_vpc.this.id }
