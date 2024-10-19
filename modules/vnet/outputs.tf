output "id" {
  value = azurerm_virtual_network.this.id
}

output "name" {
  value = azurerm_virtual_network.this.name
}


output "resource_group_name" {
  value = azurerm_virtual_network.this.resource_group_name
}


output "subnet_ids" {
  value = { for s in azurerm_virtual_network.this.subnet : s.name => s.id }
}