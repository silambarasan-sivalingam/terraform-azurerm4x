output "id" {
  description = "The Nat Gateway ID"
  value       = azurerm_nat_gateway.this.id
}

output "resource_guid" {
  description = "The resource GUID property of the NAT Gateway."
  value       = azurerm_nat_gateway.this.resource_guid
}