package terraform.remote_state

default deny = []

# Enforce remote state backends with encryption and locking whenever a backend is used.
deny[msg] {
  input.resource_type == "terraform_backend_s3"
  not input.values.encrypt
  msg := "Terraform S3 backend must enable encryption"
}

deny[msg] {
  input.resource_type == "terraform_backend_s3"
  not input.values.dynamodb_table
  msg := "Terraform S3 backend must configure DynamoDB state locking"
}

deny[msg] {
  input.resource_type == "terraform_backend_azurerm"
  not input.values.storage_account_name
  msg := "Terraform azurerm backend must specify storage account (with encryption/immutability at account policy)"
}
