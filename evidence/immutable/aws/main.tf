terraform {
  required_providers { aws = { source="hashicorp/aws", version="~> 5.62" } }
}
provider "aws" { region = var.region }
variable "region" { type = string }
variable "bucket" { type = string }

resource "aws_kms_key" "evidence" { description="Evidence KMS"; enable_key_rotation=true }

resource "aws_s3_bucket" "evidence" { bucket = var.bucket }
resource "aws_s3_bucket_versioning" "v" { bucket = aws_s3_bucket.evidence.id versioning_configuration { status = "Enabled" } }
resource "aws_s3_bucket_object_lock_configuration" "lock" {
  bucket = aws_s3_bucket.evidence.id
  rule { default_retention { mode = "COMPLIANCE" days = 365 } }
}
resource "aws_s3_bucket_server_side_encryption_configuration" "sse" {
  bucket = aws_s3_bucket.evidence.id
  rule { apply_server_side_encryption_by_default { sse_algorithm = "aws:kms", kms_master_key_id = aws_kms_key.evidence.arn } }
}
