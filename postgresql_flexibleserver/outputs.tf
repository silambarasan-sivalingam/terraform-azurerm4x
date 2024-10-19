output "id" {
  value       = azurerm_postgresql_flexible_server.this.id
  description = "The ID of this PostgreSQL Flexible Server"
}

output "name" {
  value       = azurerm_postgresql_flexible_server.this.name
  description = "The name of this PostgreSQL Flexible Server"
}

output "administrator_login" {
  value       = azurerm_postgresql_flexible_server.this.administrator_login
  description = "The Administrator login for the PostgreSQL Flexible Server."
}

output "fqdn" {
  value       = azurerm_postgresql_flexible_server.this.fqdn
  description = "The fqdn login for the PostgreSQL Flexible Server."
}

output "version" {
  value       = azurerm_postgresql_flexible_server.this.version
  description = "The version login for the PostgreSQL Flexible Server."
}
