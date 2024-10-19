output "id" {
  value       = azurerm_mysql_flexible_server.this.id
  description = "The ID of this MySQL Flexible Server"
}

output "name" {
  value       = azurerm_mysql_flexible_server.this.name
  description = "The name of this MySQL Flexible Server"
}

output "administrator_login" {
  value       = azurerm_mysql_flexible_server.this.administrator_login
  description = "The Administrator login for the MySQL Flexible Server."
}

output "fqdn" {
  value       = azurerm_mysql_flexible_server.this.fqdn
  description = "The fqdn login for the MySQL Flexible Server."
}

output "version" {
  value       = azurerm_mysql_flexible_server.this.version
  description = "The version login for the MySQL Flexible Server."
}

output "administrator_password" {
  description = "Administrator password for MySQL server"
  value       = azurerm_mysql_flexible_server.this.administrator_password
  sensitive   = true
}

output "databases_names" {
  description = "List of databases names"
  value       = [for db in azurerm_mysql_flexible_database.this : db.name]
}