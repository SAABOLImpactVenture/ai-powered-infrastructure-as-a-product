package terraform.baseline

__required_tags := {"Program","System","Environment","Data-Class"}

default deny = []

deny[msg] {
  input.resource_type == "aws_s3_bucket"
  not input.values.server_side_encryption_configuration
  msg := "AWS S3 bucket must enable SSE with KMS"
}

deny[msg] {
  input.resource_type == "aws_s3_bucket_public_access_block"
  not input.values.block_public_acls
  msg := "AWS S3 public access must be blocked (ACLs)"
}

deny[msg] {
  input.resource_type == "aws_s3_bucket_public_access_block"
  not input.values.block_public_policy
  msg := "AWS S3 public access must be blocked (bucket policy)"
}

deny[msg] {
  input.resource_type == "azurerm_storage_account"
  not input.values.min_tls_version
  msg := "Azure Storage must set min TLS version >= 1.2"
}

deny[msg] {
  input.resource_type == "azurerm_storage_account"
  not input.values.enable_https_traffic_only
  msg := "Azure Storage must enforce HTTPS only"
}

deny[msg] {
  input.resource_type == "azurerm_storage_account"
  not input.values.infrastructure_encryption_enabled
  msg := "Azure Storage must enable infra encryption"
}

deny[msg] {
  input.resource_type == "google_storage_bucket"
  not input.values.uniform_bucket_level_access
  msg := "GCS bucket must enable uniform access control"
}

deny[msg] {
  input.resource_type == "google_storage_bucket"
  not input.values.encryption[0].default_kms_key_name
  msg := "GCS bucket must specify CMEK"
}

deny[msg] {
  some tag
  __required_tags[tag]
  not input.values.tags[tag]
  msg := sprintf("Required tag missing: %s", [tag])
}
