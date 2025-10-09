terraform {
  required_providers { aws = { source = "hashicorp/aws", version = ">= 5.62" } }
}
provider "aws" { region = var.region }
variable "region" { type=string }
variable "db_name" { type=string }
variable "username" { type=string }
variable "password" { type=string }
resource "aws_db_instance" "pg" {
  identifier = var.db_name
  engine = "postgres"
  instance_class = "db.t4g.micro"
  allocated_storage = 20
  username = var.username
  password = var.password
  skip_final_snapshot = true
  backup_retention_period = 7
  copy_tags_to_snapshot = true
  multi_az = true
}
