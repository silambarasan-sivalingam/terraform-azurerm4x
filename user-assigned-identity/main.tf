resource "azurerm_user_assigned_identity" "this" {
  name                = var.settings.name
  location            = var.settings.location
  resource_group_name = var.settings.resource_group_name
  tags                = var.settings.tags
}

resource "azurerm_role_assignment" "this" {
  for_each = try({
    for x in var.settings.role_assignment :
    "${x.scope}_${x.role_definition_name}" => x
  }, {})
  scope                = each.value.scope
  role_definition_name = each.value.role_definition_name
  principal_id         = azurerm_user_assigned_identity.this.principal_id
}
