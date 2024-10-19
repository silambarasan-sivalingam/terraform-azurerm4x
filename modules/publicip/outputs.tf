output "id" {
  description = "The ID of this Public IP."
  value       = azurerm_public_ip.this.id
}

output "ip_address" {
  description = " The IP address value that was allocated."
  value       = azurerm_public_ip.this.ip_address
}
