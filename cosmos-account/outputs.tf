output "id" {
  value       = azurerm_cosmosdb_account.this.id
  description = "The CosmosDB Account ID."
}

output "endpoint" {
  value       = azurerm_cosmosdb_account.this.endpoint
  description = "The endpoint used to connect to the CosmosDB account."
}

output "read_endpoints" {
  value       = azurerm_cosmosdb_account.this.read_endpoints
  description = " A list of read endpoints available for this CosmosDB account."
}

output "write_endpoints" {
  value       = azurerm_cosmosdb_account.this.write_endpoints
  description = " A list of read endpoints available for this CosmosDB account."
}

output "primary_key" {
  value       = azurerm_cosmosdb_account.this.primary_key
  description = "The Primary key for the CosmosDB Account."
}

output "secondary_key" {
  value       = azurerm_cosmosdb_account.this.secondary_key
  description = "The Secondary key for the CosmosDB Account."
}

output "primary_readonly_key" {
  value       = azurerm_cosmosdb_account.this.primary_readonly_key
  description = " The Primary read-only Key for the CosmosDB Account."
}

output "secondary_readonly_key" {
  value       = azurerm_cosmosdb_account.this.secondary_readonly_key
  description = "The Secondary read-only key for the CosmosDB Account."
}

output "connection_strings" {
  value       = azurerm_cosmosdb_account.this.connection_strings
  description = "A list of connection strings available for this CosmosDB account"
}