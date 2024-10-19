variable "settings" {
  description = "Settings for the Azure Monitor activity log alert."
  type = object({
    name                = string
    resource_group_name = string
    scopes              = list(string)
    enabled             = bool
    description         = optional(string)
    tags                = map(string)
    action = optional(list(object({
      action_group_id    = string
      webhook_properties = optional(map(string))
    })))
    criteria = optional(list(object({
      category                = string
      caller                  = optional(string)
      operation_name          = string
      resource_provider       = optional(string)
      resource_providers      = optional(list(string))
      resource_type           = optional(string)
      resource_types          = optional(list(string))
      resource_group          = optional(string)
      resource_groups         = optional(list(string))
      resource_id             = optional(string)
      resource_ids            = optional(list(string))
      level                   = optional(string)
      levels                  = optional(list(string))
      status                  = optional(string)
      statuses                = optional(list(string))
      sub_status              = optional(string)
      sub_statuses            = optional(list(string))
      recommendation_type     = optional(string)
      recommendation_category = optional(string)
      recommendation_impact   = optional(string)

      resource_health = optional(list(object({
        current  = string
        previous = string
        reason   = string
      })))

      service_health = optional(list(object({
        events    = optional(list(string))
        locations = optional(list(string))
        services  = optional(list(string))
      })))

    })))
  })
}
