resource "random_password" "this" {
  length           = 21
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "azurerm_resource_group_template_deployment" "terraform-arm" {
  name                = var.settings.arm_name
  resource_group_name = var.settings.resource_group_name
  deployment_mode     = var.settings.deployment_mode
  #template_content    = file("template.json")
  template_content = file("${path.module}/template.json")
  parameters_content = jsonencode({
    "CLUSTER_NAME" = {
      value = var.settings.cluster_name
    }
    "administratorLogin" = {
      value = var.settings.administrator_login
    },
    "administratorLoginPassword" = {
      value = random_password.this.result
    },
    "location" = {
      value = var.settings.location
    },
    "serverVersion" = {
      value = var.settings.server_version
    },
    "sku" = {
      value = var.settings.sku
    }
  })
  # lifecycle {
  #   ignore_changes = [ parameters_content ]
  # }
}

resource "azurerm_key_vault_secret" "this" {
  for_each        = try({ for n in var.settings.key_vault_secret : n.name => n }, {})
  name            = each.key
  value           = random_password.this.result
  key_vault_id    = each.value.key_vault_id
  tags            = var.settings.tags
  expiration_date = "2026-12-31T00:00:00Z"
}

resource "azurerm_private_endpoint" "this" {
  count                         = var.settings.private_endpoint != null ? 1 : 0
  name                          = "pe-${var.settings.cluster_name}"
  location                      = var.settings.location
  resource_group_name           = var.settings.resource_group_name
  subnet_id                     = var.settings.private_endpoint.subnet_id
  custom_network_interface_name = replace("pe-${var.settings.cluster_name}", "pe-", "penic-")
  tags                          = var.settings.tags
  private_service_connection {
    name                           = "pe-${var.settings.cluster_name}"
    private_connection_resource_id = var.settings.cluster_id
    is_manual_connection           = false
    subresource_names              = var.settings.private_endpoint.subresource_names
  }

  dynamic "private_dns_zone_group" {
    for_each = var.settings.private_endpoint.private_dns_zone_ids != null ? ["enabled"] : []
    content {
      name                 = "pe-${var.settings.cluster_name}-dns-zone-group"
      private_dns_zone_ids = var.settings.private_endpoint.private_dns_zone_ids
    }
  }
  depends_on = [azurerm_resource_group_template_deployment.terraform-arm]
}
