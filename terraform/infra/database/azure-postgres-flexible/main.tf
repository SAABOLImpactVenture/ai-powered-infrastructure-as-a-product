locals {
  name = lower("${var.name_prefix}-pgflex")
}

resource "random_password" "admin" {
  length           = 24
  special          = true
  override_characters = "_-!@$%&*+"
}

resource "azurerm_postgresql_flexible_server" "db" {
  name                   = local.name
  resource_group_name    = var.resource_group_name
  location               = var.location

  version                = var.postgres_version
  sku_name               = var.sku_name
  storage_mb             = 32768
  backup_retention_days  = var.backup_retention_days
  zone                   = "1"

  high_availability {
    mode = "ZoneRedundant"
  }

  authentication {
    active_directory_auth_enabled = false
    password_auth_enabled         = true
  }

  administrator_login          = var.admin_username
  administrator_password        = random_password.admin.result

  storage_tier = "P30"

  tags = var.tags
}

# Create application database
resource "azurerm_postgresql_flexible_server_database" "appdb" {
  name      = var.db_name
  server_id = azurerm_postgresql_flexible_server.db.id
  charset   = "UTF8"
  collation = "en_US.UTF8"
}

# Private endpoint for the server
resource "azurerm_private_endpoint" "pg_pe" {
  name                = "${local.name}-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "${local.name}-pe-conn"
    private_connection_resource_id = azurerm_postgresql_flexible_server.db.id
    subresource_names              = ["postgresqlServer"]
    is_manual_connection           = false
  }

  tags = var.tags
}

# Store secrets in Key Vault
resource "azurerm_key_vault_secret" "pg_host" {
  name         = "${local.name}-host"
  value        = azurerm_postgresql_flexible_server.db.fqdn
  key_vault_id = var.kv_id
}

resource "azurerm_key_vault_secret" "pg_port" {
  name         = "${local.name}-port"
  value        = "5432"
  key_vault_id = var.kv_id
}

resource "azurerm_key_vault_secret" "pg_admin_user" {
  name         = "${local.name}-admin-user"
  value        = var.admin_username
  key_vault_id = var.kv_id
}

resource "azurerm_key_vault_secret" "pg_admin_password" {
  name         = "${local.name}-admin-password"
  value        = random_password.admin.result
  key_vault_id = var.kv_id
}

resource "azurerm_key_vault_secret" "pg_db_name" {
  name         = "${local.name}-db-name"
  value        = var.db_name
  key_vault_id = var.kv_id
}

output "postgres_fqdn" {
  value = azurerm_postgresql_flexible_server.db.fqdn
}

output "kv_secret_names" {
  value = {
    host     = azurerm_key_vault_secret.pg_host.name
    port     = azurerm_key_vault_secret.pg_port.name
    admin    = azurerm_key_vault_secret.pg_admin_user.name
    password = azurerm_key_vault_secret.pg_admin_password.name
    db_name  = azurerm_key_vault_secret.pg_db_name.name
  }
}
