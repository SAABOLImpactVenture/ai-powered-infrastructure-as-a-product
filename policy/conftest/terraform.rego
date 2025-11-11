package terraform.security
deny[msg] {
  some i
  rc := input.resource_changes[i]
  rc.type == "azurerm_storage_account"
  rc.change.after_properties.allowBlobPublicAccess == true
  msg := sprintf("Public blob access is not allowed for storage account %s", [rc.name])
}
deny[msg] {
  some i
  rc := input.resource_changes[i]
  rc.type == "aws_s3_bucket_public_access_block"
  rc.change.after_properties.block_public_acls == false
  msg := "S3 bucket public ACLs must be blocked"
}
