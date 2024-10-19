variable "settings" {
  description = "function App Service Plan configuration."
  type = object({
    name                            = string
    location                        = string
    resource_group_name             = string
    service_plan_id                 = string
    public_network_access_enabled   = string
    storage_account_name            = optional(string)
    storage_account_access_key      = optional(string)
    virtual_network_subnet_id       = optional(string)
    key_vault_reference_identity_id = optional(string)

    application_stack = object({
      python_version          = optional(string)
      node_version            = optional(string)
      powershell_core_version = optional(string)
    })

    app_settings = optional(map(string))

    identity = optional(object({
      type         = optional(string)
      identity_ids = optional(list(string))
    }))

    private_endpoint = object({
      subnet_id            = string
      private_dns_zone_ids = list(string)
    })

    tags = optional(map(string), null)
  })
}
