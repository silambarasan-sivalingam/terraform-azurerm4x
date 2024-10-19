output "name" {
  description = "The name of the key vault created."
  value       = azurerm_key_vault.this.name
}

output "id" {
  description = "The id of the key vault created."
  value       = azurerm_key_vault.this.id
}

output "url" {
  description = "The url of the key vault created."
  value       = azurerm_key_vault.this.vault_uri
  sensitive   = true
}

output "key_versionless_id" {
  description = "Map containing the IDs of all keys within the key vault, indexed by key name."
  value       = { for key_name, key_data in azurerm_key_vault_key.this : key_name => key_data.versionless_id }
}

# output "eventhub_id" {
#   description = "The ID of the EventHub."
#   value       = [for e in azurerm_eventhub.this : e.id]
# }