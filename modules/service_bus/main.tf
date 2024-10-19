data "azurerm_client_config" "this" {}

resource "azurerm_servicebus_namespace" "this" {
  name                          = var.settings.name
  location                      = var.settings.location
  resource_group_name           = var.settings.resource_group_name
  sku                           = var.settings.sku
  local_auth_enabled            = var.settings.local_auth_enabled
  minimum_tls_version           = var.settings.minimum_tls_version
  zone_redundant                = var.settings.zone_redundant
  capacity                      = var.settings.capacity
  public_network_access_enabled = var.settings.public_network_access_enabled
  premium_messaging_partitions  = var.settings.premium_messaging_partitions
  tags                          = var.settings.tags
 
 dynamic "identity" {
    for_each = var.settings.identity != null ? [var.settings.identity] : []
    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }

dynamic "network_rule_set" {
    for_each = var.settings.network_rule_set != null ? [var.settings.network_rule_set] : []
    content {
      default_action           = network_rule_set.value.default_action
      trusted_services_allowed = network_rule_set.value.trusted_services_allowed
      public_network_access_enabled = network_rule_set.value.public_network_access_enabled
    }
  }

dynamic "customer_managed_key" {
    for_each = var.settings.customer_managed_key != null ? [var.settings.customer_managed_key] : []
    content {
      key_vault_key_id                   = customer_managed_key.value.key_vault_key_id
      identity_id                        = customer_managed_key.value.identity_id
       infrastructure_encryption_enabled = customer_managed_key.value.infrastructure_encryption_enabled
    }
  }
}
 
resource "azurerm_servicebus_queue" "this" {
  for_each         = try({ for q in var.settings.servicebus_queue : q.name => q }, {})
  name             = each.key
  namespace_id     = azurerm_servicebus_namespace.this.id
  requires_session = each.value.requires_session
}
 
 
resource "azurerm_private_endpoint" "this" {
  name                          = "pe-${var.settings.name}"
  location                      = var.settings.location
  resource_group_name           = var.settings.resource_group_name
  subnet_id                     = var.settings.private_endpoint.subnet_id
  custom_network_interface_name = "penic-${var.settings.name}"
  private_service_connection {
    name                           = "pe-${var.settings.name}"
    private_connection_resource_id = azurerm_servicebus_namespace.this.id
    is_manual_connection           = false
    subresource_names              = ["namespace"]
  }
 
  private_dns_zone_group {
    name                 = "pe-${var.settings.name}-dns-zone-group"
    private_dns_zone_ids = var.settings.private_endpoint.private_dns_zone_ids
  }
  tags = var.settings.tags
}


resource "azurerm_monitor_autoscale_setting" "this" {
  #for_each         = try({ for autoscale in var.settings.autoscale_setting : autoscale.name => autoscale }, {})
  #for_each = var.settings.autoscale_setting != null ? var.settings.autoscale_setting : {}
  name                = var.settings.autoscale_setting.name
  resource_group_name = var.settings.resource_group_name
  location            = var.settings.location
  target_resource_id  = azurerm_servicebus_namespace.this.id

  profile {
    name = var.settings.autoscale_setting.name

    capacity {
      default = 1
      minimum = 1
      maximum = 16
    }

    dynamic "rule" {
      for_each = (var.settings.autoscale_setting.rule == null) ? [] : var.settings.autoscale_setting.rule
      content {
        metric_trigger {
          metric_name        = rule.value.metric_trigger.metric_name
          metric_resource_id = azurerm_servicebus_namespace.this.id
          time_grain         = rule.value.metric_trigger.time_grain
          statistic          = rule.value.metric_trigger.statistic
          time_window        = rule.value.metric_trigger.time_window
          time_aggregation   = rule.value.metric_trigger.time_aggregation
          operator           = rule.value.metric_trigger.operator
          threshold          = rule.value.metric_trigger.threshold
          #metric_namespace   = "microsoft.servicebus/namespaces"
          #metric_namespace   = "Microsoft.Insights/autoscaleSettings"
        }

        scale_action {
          direction = rule.value.scale_action.direction
          type      = rule.value.scale_action.type
          value     = rule.value.scale_action.value
          cooldown  = rule.value.scale_action.cooldown
        }
      }
    }
  }

  /*predictive {
    scale_mode      = each.value.profile.predictive.scale_mode
    look_ahead_time = each.value.profile.predictive.look_ahead_time
  }*/
}

