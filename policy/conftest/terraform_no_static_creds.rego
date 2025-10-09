package tf.secure

deny[msg] {
  input.block.type == "provider"
  input.block.labels[0] == "aws"
  input.block.body[_].type == "attribute"
  input.block.body[_].attributes["access_key"]
  msg = "AWS provider must not set access_key; use OIDC"
}

deny[msg] {
  input.block.type == "provider"
  input.block.labels[0] == "aws"
  input.block.body[_].type == "attribute"
  input.block.body[_].attributes["secret_key"]
  msg = "AWS provider must not set secret_key; use OIDC"
}

deny[msg] {
  input.block.type == "provider"
  input.block.labels[0] == "google"
  input.block.body[_].type == "attribute"
  input.block.body[_].attributes["credentials"]
  msg = "GCP provider credentials JSON is forbidden; use WIF"
}

deny[msg] {
  input.block.type == "provider"
  input.block.labels[0] == "azurerm"
  input.block.body[_].type == "attribute"
  input.block.body[_].attributes["client_secret"]
  msg = "Azure provider client_secret forbidden; use federation"
}
