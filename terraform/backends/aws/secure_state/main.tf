terraform {
  required_providers { aws = { source="hashicorp/aws", version=">= 5.62" } }
}
provider "aws" { region = var.region }
variable "region" { type=string }
variable "name"   { type=string }

resource "aws_kms_key" "tf" { description = "TF state KMS"; enable_key_rotation = true }
resource "aws_s3_bucket" "state" { bucket = var.name }
resource "aws_s3_bucket_versioning" "v" { bucket = aws_s3_bucket.state.id versioning_configuration { status="Enabled" } }
resource "aws_s3_bucket_server_side_encryption_configuration" "sse" {
  bucket = aws_s3_bucket.state.id
  rule { apply_server_side_encryption_by_default { kms_master_key_id = aws_kms_key.tf.arn, sse_algorithm = "aws:kms" } }
}
resource "aws_dynamodb_table" "lock" {
  name = "${var.name}-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "LockID"
  attribute { name="LockID" type="S" }
}
resource "aws_s3_bucket_policy" "deny_public" {
  bucket = aws_s3_bucket.state.id
  policy = jsonencode({
    Version="2012-10-17",
    Statement=[{ Sid:"DenyPublic", Effect:"Deny", Principal:"*", Action:"s3:*", Resource:[aws_s3_bucket.state.arn, "${aws_s3_bucket.state.arn}/*"], Condition:{ Bool:{ "aws:SecureTransport":"false" } } }]
  })
}

output "backend" {
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
