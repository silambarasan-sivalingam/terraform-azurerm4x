variable "settings" {
  description = "monitor metric alert"
  type = object({
    name                     = string
    resource_group_name      = string
    scopes                   = list(string)
    enabled                  = optional(bool)
    auto_mitigate            = optional(bool)
    description              = optional(string)
    frequency                = optional(string)
    severity                 = optional(number)
    target_resource_type     = optional(string)
    target_resource_location = optional(string)
    window_size              = optional(string)
    tags                     = optional(map(string))

    action = optional(list(object({
      action_group_id    = string
      webhook_properties = optional(map(string))
    })))

    criteria = optional(list(object({
      metric_namespace       = string
      metric_name            = string
      aggregation            = string
      operator               = string
      threshold              = number
      skip_metric_validation = optional(bool)

      dimension = optional(list(object({
        name     = string
        operator = string
        values   = list(string)
      })))
    })))

    dynamic_criteria = optional(list(object({
      metric_namespace         = string
      metric_name              = string
      aggregation              = string
      operator                 = string
      alert_sensitivity        = string
      evaluation_total_count   = optional(number)
      evaluation_failure_count = optional(number)
      ignore_data_before       = optional(string)
      skip_metric_validation   = optional(bool)

      dimension = optional(list(object({
        name     = string
        operator = string
        values   = list(string)
      })))
    })))

    application_insights_web_test_location_availability_criteria = optional(list(object({
      web_test_id           = string
      component_id          = string
      failed_location_count = string
    })))

  })
}
