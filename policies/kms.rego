package terraform.kms

default deny = []

deny[msg] {
  input.resource_type == "aws_kms_key"
  not input.values.enable_key_rotation
  msg := "AWS KMS keys must enable rotation"
}

deny[msg] {
  input.resource_type == "azurerm_key_vault_key"
  not input.values.rotation_policy[0].lifetime_actions[0].trigger[0].time_after_create
  msg := "Azure Key Vault keys must define rotation policy"
}
