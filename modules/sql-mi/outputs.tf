output "id" {
  value       = azurerm_mssql_managed_instance.this.id
  description = "The SQL Managed Instance ID."
}

output "fqdn" {
  value       = azurerm_mssql_managed_instance.this.fqdn
  description = "The fully qualified domain name of the Azure Managed SQL Instance"
}