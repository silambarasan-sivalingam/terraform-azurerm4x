resource "azurerm_nat_gateway" "this" {
  name                    = var.settings.name
  resource_group_name     = var.settings.resource_group_name
  location                = var.settings.location
  sku_name                = var.settings.sku_name
  idle_timeout_in_minutes = var.settings.idle_timeout_in_minutes
  zones                   = var.settings.zones
  tags                    = var.settings.tags
}


resource "azurerm_nat_gateway_public_ip_association" "this" {
  for_each             = try({ for n in var.settings.nat_gateway_public_ip_association : n.public_ip_address_id => n }, {})
  nat_gateway_id       = azurerm_nat_gateway.this.id
  public_ip_address_id = each.key
}


resource "azurerm_nat_gateway_public_ip_prefix_association" "this" {
  for_each            = try({ for n in var.settings.nat_gateway_public_ip_prefix_association : n.public_ip_prefix_id => n }, {})
  nat_gateway_id      = azurerm_nat_gateway.this.id
  public_ip_prefix_id = each.key
}

resource "azurerm_subnet_nat_gateway_association" "this" {
  for_each       = try({ for n in var.settings.subnet_nat_gateway_association : n.subnet_id => n }, {})
  subnet_id      = each.key
  nat_gateway_id = azurerm_nat_gateway.this.id
}
