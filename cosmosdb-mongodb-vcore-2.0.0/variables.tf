variable "settings" {
  description = "Cosmos configuration."
  type = object({
    arm_name            = string
    resource_group_name = string
    deployment_mode     = string
    cluster_name        = string
    administrator_login = string
    location            = string
    server_version      = string
    sku                 = string
    tags                = optional(map(string))
    cluster_id          = string

    key_vault_secret = optional(list(object({
      name         = string
      key_vault_id = string
    })))
    private_endpoint = optional(object({
      subnet_id            = string
      private_dns_zone_ids = optional(list(string))
      subresource_names    = list(string)
    }))
  })
}