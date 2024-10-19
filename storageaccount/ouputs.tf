output "storage_account_properties" {
  description = "Created Storage Account properties."
  value       = azurerm_storage_account.this
}

output "id" {
  description = "Created Storage Account ID."
  value       = azurerm_storage_account.this.id
}

output "storage_account_name" {
  description = "Created Storage Account name."
  value       = azurerm_storage_account.this.name
}

output "primary_access_key" {
  description = "Created queues in the Storage Account."
  value       = azurerm_storage_account.this.primary_access_key
}

output "storage_account_identity" {
  description = "Created Storage Account identity block."
  value       = azurerm_storage_account.this.identity
}

output "storage_blob_containers" {
  description = "Created blob containers in the Storage Account."
  value       = azurerm_storage_container.this
}

output "storage_file_shares" {
  description = "Created file shares in the Storage Account."
  value       = azurerm_storage_share.this
}

output "storage_file_tables" {
  description = "Created tables in the Storage Account."
  value       = azurerm_storage_table.this
}

output "storage_file_queues" {
  description = "Created queues in the Storage Account."
  value       = azurerm_storage_queue.this
}

