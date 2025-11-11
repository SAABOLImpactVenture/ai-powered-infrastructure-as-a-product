output "server_name" {
  value = azurerm_postgresql_flexible_server.db.name
}

output "database_name" {
  value = azurerm_postgresql_flexible_server_database.appdb.name
}

output "private_endpoint_id" {
  value = azurerm_private_endpoint.pg_pe.id
}

output "key_vault_secret_names" {
  value = {
    host     = azurerm_key_vault_secret.pg_host.name
    port     = azurerm_key_vault_secret.pg_port.name
    admin    = azurerm_key_vault_secret.pg_admin_user.name
    password = azurerm_key_vault_secret.pg_admin_password.name
    db_name  = azurerm_key_vault_secret.pg_db_name.name
  }
}
