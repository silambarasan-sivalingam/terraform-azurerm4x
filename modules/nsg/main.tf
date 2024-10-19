resource "azurerm_network_security_group" "this" {
  name                = var.settings.name
  location            = var.settings.location
  resource_group_name = var.settings.resource_group_name

  dynamic "security_rule" {
    for_each = (var.settings.security_rule == null) ? {} : var.settings.security_rule
    content {
      name                                       = security_rule.key
      description                                = security_rule.value.description
      priority                                   = security_rule.value.priority
      direction                                  = security_rule.value.direction
      access                                     = security_rule.value.access
      protocol                                   = security_rule.value.protocol
      source_port_range                          = security_rule.value.source_port_range
      destination_port_range                     = security_rule.value.destination_port_range
      source_address_prefix                      = security_rule.value.source_address_prefix
      destination_address_prefix                 = security_rule.value.destination_address_prefix
      source_port_ranges                         = security_rule.value.source_port_ranges
      destination_port_ranges                    = security_rule.value.destination_port_ranges
      source_address_prefixes                    = security_rule.value.source_address_prefixes
      destination_address_prefixes               = security_rule.value.destination_address_prefixes
      source_application_security_group_ids      = security_rule.value.source_application_security_group_ids
      destination_application_security_group_ids = security_rule.value.destination_application_security_group_ids
    }
  }
  tags = var.settings.tags
#   lifecycle {
 #    ignore_changes = [
  #     security_rule
  #   ]
  # }
}
# resource "azurerm_subnet_network_security_group_association" "this" {
#   network_security_group_id = azurerm_network_security_group.this.id
#   subnet_id                 = var.settings.subnet_id
# }
