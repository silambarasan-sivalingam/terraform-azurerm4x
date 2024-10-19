resource "azurerm_route_table" "this" {
  name                          = var.settings.name
  location                      = var.settings.location
  resource_group_name           = var.settings.resource_group_name
  disable_bgp_route_propagation = var.settings.disable_bgp_route_propagation

  dynamic "route" {
    for_each = (var.settings.route == null) ? [] : var.settings.route
    content {
      name                   = route.value.name
      address_prefix         = route.value.address_prefix
      next_hop_type          = route.value.next_hop_type
      next_hop_in_ip_address = route.value.next_hop_in_ip_address
    }
  }
  tags = var.settings.tags
  lifecycle {
    ignore_changes = [route]
  }
}

resource "azurerm_subnet_route_table_association" "this" {

  for_each = var.settings.subnets != null ? { for s in var.settings.subnets : s.subnet_id => s } : {}

  subnet_id      = each.value.subnet_id
  route_table_id = azurerm_route_table.this.id

}
