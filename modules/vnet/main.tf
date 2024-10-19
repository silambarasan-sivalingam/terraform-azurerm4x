resource "azurerm_virtual_network" "this" {
  name                = var.settings.name
  resource_group_name = var.settings.resource_group_name
  location            = var.settings.location
  address_space       = var.settings.address_space
  dns_servers         = var.settings.dns_servers

  dynamic "subnet" {
    for_each = var.settings.subnets != null ? var.settings.subnets : []
    content {
      name           = subnet.value.name
      address_prefix = subnet.value.address_prefix
      security_group = subnet.value.security_group
    }
  }
  tags = var.settings.tags
}

data "azurerm_subnet" "this" {
  for_each = {
    for subnet in var.settings.subnets :
    subnet.name => subnet
  }
  name                 = each.key
  virtual_network_name = azurerm_virtual_network.this.name
  resource_group_name  = var.settings.resource_group_name
  depends_on           = [azurerm_virtual_network.this]
}

resource "azapi_update_resource" "this" {
  for_each = {
    for subnet in var.settings.subnets :
    subnet.name => subnet if length(subnet.service_endpoints) > 0 || length(subnet.delegations) > 0
  }
  type = "Microsoft.Network/virtualNetworks/subnets@2022-05-01"

  resource_id = data.azurerm_subnet.this[each.key].id

  body = jsonencode({
    properties = {
      serviceEndpoints = length(each.value.service_endpoints) > 0 ? [for se in each.value.service_endpoints : {
        service = se
      }] : [],
      delegations = length(each.value.delegations) > 0 ? [for d in each.value.delegations : {
        name = d.name
        properties = {
          serviceName = d.service_name
          actions     = d.actions
        }
      }] : []
    }
  })
  lifecycle {
    ignore_changes = [resource_id]
  }
}
