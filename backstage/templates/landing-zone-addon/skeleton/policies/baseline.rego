package terraform.baseline

deny[msg] {
  input.resource_type == "aws_s3_bucket"
  not input.values.server_side_encryption_configuration
  msg := "AWS S3 bucket must enable SSE with KMS"
}

deny[msg] {
  some tag
  required := {"Program","System","Environment","Data-Class"}
  required[tag]
  not input.values.tags[tag]
  msg := sprintf("Required tag missing: %s", [tag])
}
