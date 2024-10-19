output "id" {
  value       = azurerm_monitor_private_link_scope.this.id
  description = "The azurerm_function_app ID."
}

output "private_ips" {
  value = [for conn in azurerm_private_endpoint.this.private_service_connection : conn.private_ip_address]
}
