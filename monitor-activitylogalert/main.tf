resource "azurerm_monitor_activity_log_alert" "this" {
  name                = var.settings.name
  resource_group_name = var.settings.resource_group_name
  scopes              = var.settings.scopes
  enabled             = var.settings.enabled
  description         = var.settings.description
  tags                = var.settings.tags



  dynamic "action" {

    for_each = var.settings.action != null ? var.settings.action : []

    content {
      action_group_id    = action.value.action_group_id
      webhook_properties = action.value.webhook_properties
    }
  }

  dynamic "criteria" {
    for_each = var.settings.criteria != null ? var.settings.criteria : []
    content {
      category                = criteria.value.category
      caller                  = criteria.value.caller
      operation_name          = criteria.value.operation_name
      resource_provider       = criteria.value.resource_provider
      resource_providers      = criteria.value.resource_providers
      resource_type           = criteria.value.resource_type
      resource_types          = criteria.value.resource_types
      resource_group          = criteria.value.resource_group
      resource_groups         = criteria.value.resource_groups
      resource_id             = criteria.value.resource_id
      resource_ids            = criteria.value.resource_ids
      level                   = criteria.value.level
      levels                  = criteria.value.levels
      status                  = criteria.value.status
      statuses                = criteria.value.statuses
      sub_status              = criteria.value.sub_status
      sub_statuses            = criteria.value.sub_statuses
      recommendation_type     = criteria.value.recommendation_type
      recommendation_category = criteria.value.recommendation_category
      recommendation_impact   = criteria.value.recommendation_impact


      dynamic "resource_health" {
        for_each = criteria.value.resource_health != null ? criteria.value.resource_health : []
        content {
          current  = resource_health.value.current
          previous = resource_health.value.previous
          reason   = resource_health.value.reason
        }
      }

      dynamic "service_health" {
        for_each = criteria.value.service_health != null ? criteria.value.service_health : []
        content {
          events    = service_health.value.events
          locations = service_health.value.locations
          services  = service_health.value.services
        }
      }
    }
  }
  lifecycle  {
    ignore_changes = [ enabled ]
    }
}

