output "id" {
  value       = azurerm_servicebus_namespace.this.id
  description = "The servicebus_namespace ID."
}
 
output "servicebus_queue_ids" {
  value = {
    for queue_name, queue_instance in azurerm_servicebus_queue.this :
    queue_name => queue_instance.id
  }
  description = "Map of service bus queue names to their IDs."
}
