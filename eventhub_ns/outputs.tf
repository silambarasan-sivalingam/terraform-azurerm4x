output "eventhub_id" {
  description = "The ID of the EventHub."
  value       = [for e in azurerm_eventhub.this : e.id]
}

output "namespace_id" {
  description = "The EventHub Namespace ID."
  value       = azurerm_eventhub_namespace.this.id
}

output "namespace_name" {
  description = "The EventHub Namespace name."
  value       = azurerm_eventhub_namespace.this.name
}

output "id" {
  value = azurerm_eventhub_namespace.this.id
}

output "identity_principal_id" {
  value = azurerm_eventhub_namespace.this.identity[0].principal_id
}
