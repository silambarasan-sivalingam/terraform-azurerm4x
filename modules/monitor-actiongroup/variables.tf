variable "settings" {
  description = "monitor action group"
  type = object({
    name                = string
    resource_group_name = string
    short_name          = string
    enabled             = optional(string)
    location            = optional(string)
    tags                = optional(map(string))

    arm_role_receiver = optional(list(object({
      name                    = string
      role_id                 = string
      use_common_alert_schema = optional(string)
    })))

    automation_runbook_receiver = optional(list(object({
      name                    = string
      automation_account_id   = string
      runbook_name            = string
      webhook_resource_id     = string
      is_global_runbook       = string
      service_uri             = string
      use_common_alert_schema = optional(string)
    })))

    azure_app_push_receiver = optional(list(object({
      name          = string
      email_address = string
    })))

    azure_function_receiver = optional(list(object({
      name                     = string
      function_app_resource_id = string
      function_name            = string
      http_trigger_url         = string
      use_common_alert_schema  = optional(string)
    })))

    email_receiver = optional(list(object({
      name                    = string
      email_address           = string
      use_common_alert_schema = optional(string)
    })))

    event_hub_receiver = optional(list(object({
      name                    = string
      event_hub_name          = optional(string)
      event_hub_namespace     = optional(string)
      subscription_id         = optional(string)
      tenant_id               = optional(string)
      use_common_alert_schema = optional(string)
    })))

    itsm_receiver = optional(list(object({
      name                 = string
      workspace_id         = string
      connection_id        = string
      ticket_configuration = string
      region               = string
    })))

    logic_app_receiver = optional(list(object({
      name                    = string
      resource_id             = string
      callback_url            = string
      use_common_alert_schema = optional(string)
    })))

    sms_receiver = optional(list(object({
      name         = string
      country_code = string
      phone_number = string
    })))

    voice_receiver = optional(list(object({
      name         = string
      country_code = string
      phone_number = string
    })))

    webhook_receiver = optional(list(object({
      name                    = string
      service_uri             = string
      use_common_alert_schema = string

      aad_auth = optional(object({
        object_id      = string
        identifier_uri = string
        tenant_id      = string
      }))
    })))








  })
}
