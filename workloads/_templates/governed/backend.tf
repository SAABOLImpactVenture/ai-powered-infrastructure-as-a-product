terraform {
  # By default governed modules must define a remote backend.
  # The backend stanza below will be replaced by platform provisioning output.
  backend "azurerm" {}
}
