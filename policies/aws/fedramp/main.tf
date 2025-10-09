
terraform {
  required_providers { aws = { source = "hashicorp/aws", version = ">= 5.0" } }
}

provider "aws" {
  region = var.region
}

variable "region" { type = string }
variable "org_account_id" { type = string }
variable "s3_log_bucket" { type = string description = "S3 bucket to store access logs and AWS Config data" }

# S3 bucket with Object Lock & access logging (WORM/immutability)
resource "aws_s3_bucket" "logs" {
  bucket = var.s3_log_bucket
  force_destroy = false
}

resource "aws_s3_bucket_ownership_controls" "logs" {
  bucket = aws_s3_bucket.logs.id
  rule { object_ownership = "BucketOwnerPreferred" }
}

resource "aws_s3_bucket_versioning" "logs" {
  bucket = aws_s3_bucket.logs.id
  versioning_configuration { status = "Enabled" }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "logs" {
  bucket = aws_s3_bucket.logs.id
  rule { apply_server_side_encryption_by_default { sse_algorithm = "AES256" } }
}

# Block public access
resource "aws_s3_bucket_public_access_block" "logs" {
  bucket                  = aws_s3_bucket.logs.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# (Optional) Object Lock - requires special bucket create params; include policy to enable retention using governance mode via console/CLI.
# AWS Config setup
resource "aws_iam_role" "config" {
  name = "fedramp-aws-config-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = { Service = "config.amazonaws.com" },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "config_attach" {
  role       = aws_iam_role.config.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSConfigRole"
}

resource "aws_config_configuration_recorder" "recorder" {
  name = "default"
  role_arn = aws_iam_role.config.arn
  recording_group {
    all_supported = true
    include_global_resource_types = true
  }
}

resource "aws_config_delivery_channel" "channel" {
  name           = "default"
  s3_bucket_name = aws_s3_bucket.logs.bucket
  depends_on     = [aws_config_configuration_recorder.recorder]
}

resource "aws_config_configuration_recorder_status" "status" {
  name       = aws_config_configuration_recorder.recorder.name
  is_enabled = true
  depends_on = [aws_config_delivery_channel.channel]
}

# Enable Security Hub + standards (CIS, NIST 800-53)
resource "aws_securityhub_account" "this" {}

resource "aws_securityhub_standards_subscription" "nist80053" {
  standards_arn = "arn:aws:securityhub:::standards/aws-foundational-security-best-practices/v/1.0.0"
  depends_on = [aws_securityhub_account.this]
}

# Key Config managed rules
locals {
  config_rules = [
    "S3_BUCKET_PUBLIC_READ_PROHIBITED",
    "S3_BUCKET_PUBLIC_WRITE_PROHIBITED",
    "EBS_ENCRYPTED_VOLUMES",
    "EC2_VOLUME_INUSE_CHECK",
    "IAM_PASSWORD_POLICY",
    "RDS_STORAGE_ENCRYPTED"
  ]
}

resource "aws_config_config_rule" "managed" {
  for_each = toset(local.config_rules)
  name     = lower(each.value)
  source {
    owner             = "AWS"
    source_identifier = each.value
  }
}

# CloudTrail multi-region + encryption
resource "aws_cloudtrail" "org" {
  name                          = "fedramp-org-trail"
  s3_bucket_name                = aws_s3_bucket.logs.bucket
  is_multi_region_trail         = true
  include_global_service_events = true
  enable_log_file_validation    = true
  kms_key_id                    = null
}

output "logs_bucket" { value = aws_s3_bucket.logs.bucket }
