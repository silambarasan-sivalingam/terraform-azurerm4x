output "id" {
  description = "The ID of the Windows Virtual Machine."
  value       = azurerm_linux_virtual_machine.this.id
}

output "mac_address" {
  description = "The Media Access Control (MAC) Address of the Network Interface."
  value       = azurerm_network_interface.this.mac_address
}

output "private_ip_address" {
  description = "The first private IP address of the network interface."
  value       = azurerm_network_interface.this.private_ip_address
}

output "private_ip_addresses" {
  description = "The private IP addresses of the network interface."
  value       = azurerm_network_interface.this.private_ip_addresses
}

output "nicid" {
  description = "The ID of the Network Interface."
  value       = azurerm_network_interface.this.id
}

output "virtual_machine_id" {
  description = "A 128-bit identifier which uniquely identifies this Virtual Machine."
  value       = azurerm_linux_virtual_machine.this.virtual_machine_id
}

output "managed_disk_ids" {
  value = { for k, v in azurerm_managed_disk.this : k => v.id }
}

output "password" {
  value       = random_password.this.result
  sensitive   = true
  description = "VM Password"
}
