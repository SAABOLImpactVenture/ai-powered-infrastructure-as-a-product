terraform {
  required_providers { aws = { source = "hashicorp/aws", version = ">= 5.0" } }
}
provider "aws" { region = var.region }
variable "region" { type = string }
variable "bucket_name" { type = string }
variable "retention_days" { type = number, default = 90 }

resource "aws_s3_bucket" "evidence" {
  bucket = var.bucket_name
  force_destroy = false
  object_lock_enabled = true
}
resource "aws_s3_bucket_object_lock_configuration" "cfg" {
  bucket = aws_s3_bucket.evidence.id
  rule {
    default_retention {
      mode = "GOVERNANCE"
      days = var.retention_days
    }
  }
}
resource "aws_s3_bucket_versioning" "v" {
  bucket = aws_s3_bucket.evidence.id
  versioning_configuration { status = "Enabled" }
}
resource "aws_s3_bucket_server_side_encryption_configuration" "sse" {
  bucket = aws_s3_bucket.evidence.id
  rule { apply_server_side_encryption_by_default { sse_algorithm = "AES256" } }
}
output "bucket" { value = aws_s3_bucket.evidence.bucket }
