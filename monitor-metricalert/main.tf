resource "azurerm_monitor_metric_alert" "this" {
  name                     = var.settings.name
  resource_group_name      = var.settings.resource_group_name
  scopes                   = var.settings.scopes
  enabled                  = var.settings.enabled
  auto_mitigate            = var.settings.auto_mitigate
  description              = var.settings.description
  frequency                = var.settings.frequency
  severity                 = var.settings.severity
  target_resource_type     = var.settings.target_resource_type
  target_resource_location = var.settings.target_resource_location
  window_size              = var.settings.window_size
  tags                     = var.settings.tags



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
      metric_namespace       = criteria.value.metric_namespace
      metric_name            = criteria.value.metric_name
      aggregation            = criteria.value.aggregation
      operator               = criteria.value.operator
      threshold              = criteria.value.threshold
      skip_metric_validation = criteria.value.skip_metric_validation

      dynamic "dimension" {
        for_each = criteria.value.dimension != null ? criteria.value.dimension : []
        content {
          name     = dimension.value.name
          operator = dimension.value.operator
          values   = dimension.value.values
        }
      }
    }
  }

  dynamic "dynamic_criteria" {
    for_each = var.settings.dynamic_criteria != null ? var.settings.dynamic_criteria : []
    content {
      metric_namespace         = dynamic_criteria.value.metric_namespace
      metric_name              = dynamic_criteria.value.metric_name
      aggregation              = dynamic_criteria.value.aggregation
      operator                 = dynamic_criteria.value.operator
      alert_sensitivity        = dynamic_criteria.value.alert_sensitivity
      evaluation_total_count   = dynamic_criteria.value.evaluation_total_count
      evaluation_failure_count = dynamic_criteria.value.evaluation_failure_count
      ignore_data_before       = dynamic_criteria.value.ignore_data_before

      skip_metric_validation = dynamic_criteria.value.skip_metric_validation

      dynamic "dimension" {
        for_each = dynamic_criteria.value.dimension != null ? dynamic_criteria.value.dimension : []
        content {
          name     = dimension.value.name
          operator = dimension.value.operator
          values   = dimension.value.values
        }
      }
    }
  }

  dynamic "application_insights_web_test_location_availability_criteria" {
    for_each = var.settings.application_insights_web_test_location_availability_criteria != null ? var.settings.application_insights_web_test_location_availability_criteria : []

    content {
      web_test_id           = application_insights_web_test_location_availability_criteria.value.web_test_id
      component_id          = application_insights_web_test_location_availability_criteria.value.component_id
      failed_location_count = application_insights_web_test_location_availability_criteria.value.failed_location_count
    }
  }
  lifecycle  {
    ignore_changes = [ enabled ]
    }
}

