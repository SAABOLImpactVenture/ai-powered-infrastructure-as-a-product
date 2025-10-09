terraform {
  required_providers { aws = { source = "hashicorp/aws", version = ">= 5.62" } }
}
provider "aws" { region = var.region }

variable "region" { type = string }
variable "bucket_name" { type = string }

resource "aws_kms_key" "tf" { description = "TF state KMS"; enable_key_rotation = true }

resource "aws_s3_bucket" "state" { bucket = var.bucket_name }
resource "aws_s3_bucket_versioning" "v" {
  bucket = aws_s3_bucket.state.id
  versioning_configuration { status = "Enabled" }
}
resource "aws_s3_bucket_server_side_encryption_configuration" "sse" {
  bucket = aws_s3_bucket.state.id
  rule { apply_server_side_encryption_by_default { sse_algorithm = "aws:kms", kms_master_key_id = aws_kms_key.tf.arn } }
}
resource "aws_s3_bucket_public_access_block" "pab" {
  bucket                  = aws_s3_bucket.state.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
resource "aws_dynamodb_table" "lock" {
  name         = "${var.bucket_name}-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute { name = "LockID" type = "S" }
}

output "backend_block" {
  value = <<EOT
backend "s3" {
  bucket         = "${aws_s3_bucket.state.bucket}"
  key            = "global/terraform.tfstate"
  region         = "${var.region}"
  dynamodb_table = "${aws_dynamodb_table.lock.name}"
  encrypt        = true
}
EOT
}
