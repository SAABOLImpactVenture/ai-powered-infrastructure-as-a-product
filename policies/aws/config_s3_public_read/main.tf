terraform {
  required_providers { aws = { source = "hashicorp/aws", version = ">= 5.62" } }
}
provider "aws" { region = var.region }
variable "region" { type = string }

resource "aws_config_configuration_recorder" "rec" {
  name     = "default"
  role_arn = aws_iam_role.config.arn
  recording_group { all_supported = true }
}
resource "aws_iam_role" "config" {
  name = "aws-config-role"
  assume_role_policy = jsonencode({
    Version="2012-10-17", Statement=[{Effect="Allow",Principal={Service="config.amazonaws.com"},Action="sts:AssumeRole"}]
  })
}
resource "aws_iam_role_policy" "config" {
  name = "config-policy"
  role = aws_iam_role.config.id
  policy = jsonencode({Version="2012-10-17",Statement=[{Effect="Allow",Action="*",Resource="*"}]})
}
resource "aws_config_delivery_channel" "chan" {
  name           = "default"
  s3_bucket_name = aws_s3_bucket.cfg.bucket
  depends_on     = [aws_config_configuration_recorder.rec]
}
resource "aws_s3_bucket" "cfg" { bucket = "config-${random_id.s.id}" }
resource "random_id" "s" { byte_length = 4 }

resource "aws_config_config_rule" "s3_public_read_prohibited" {
  name             = "s3-bucket-public-read-prohibited"
  source { owner = "AWS"; source_identifier = "S3_BUCKET_PUBLIC_READ_PROHIBITED" }
}
