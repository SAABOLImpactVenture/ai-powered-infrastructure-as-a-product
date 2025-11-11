package terraform.policy

__required_tags := {"Program","System","Environment","Data-Class"}

deny[msg] {
  input.resource_type == "aws_s3_bucket"
  not input.values.server_side_encryption_configuration
  msg := "S3 bucket must enable SSE with KMS"
}

deny[msg] {
  input.resource_type == "aws_s3_bucket"
  input.values.acl == "public-read" or input.values.acl == "public-read-write"
  msg := "S3 bucket must not be public"
}

deny[msg] {
  input.resource_type == "azurerm_storage_account"
  not input.values.enable_https_traffic_only
  msg := "Azure Storage must enforce HTTPS only"
}

deny[msg] {
  input.resource_type == "azurerm_storage_account"
  not input.values.min_tls_version
  msg := "Azure Storage must set min TLS version >= 1.2"
}

deny[msg] {
  input.resource_type == "google_storage_bucket"
  not input.values.uniform_bucket_level_access
  msg := "GCS bucket must enable uniform access control"
}

deny[msg] {
  some tag
  __required_tags[tag]
  not input.values.tags[tag]
  msg := sprintf("Required tag missing: %s", [tag])
}
