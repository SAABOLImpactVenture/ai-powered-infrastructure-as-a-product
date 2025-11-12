# Private DNS zone for AKS API server private endpoint
resource "azurerm_private_dns_zone" "aks" {
  count               = var.private_dns_zone_id == null ? 1 : 0
  name                = "privatelink.${var.location}.azmk8s.io"
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "aks" {
  count                 = var.private_dns_zone_id == null ? 1 : 0
  name                  = "${var.name_prefix}-aks-dns-link"
  private_dns_zone_name = azurerm_private_dns_zone.aks[0].name
  resource_group_name   = var.resource_group_name
  virtual_network_id    = azurerm_virtual_network.vnet.id
  registration_enabled  = false
}

locals {
  private_dns_zone_id_final = var.private_dns_zone_id != null ? var.private_dns_zone_id : one(azurerm_private_dns_zone.aks[*].id)
}
