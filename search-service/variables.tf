variable "settings" {
  description = "cognitive search configuration."
  type = object({
    name                                     = string
    location                                 = string
    resource_group_name                      = string
    sku                                      = string
    replica_count                            = number
    partition_count                          = number
    public_network_access_enabled            = optional(bool, false)
    local_authentication_enabled             = optional(bool)
    allowed_ips                              = optional(list(string))
    customer_managed_key_enforcement_enabled = optional(bool)
    semantic_search_sku                      = optional(string)
    hosting_mode                             = optional(string, "default")
    authentication_failure_mode              = optional(string)

    identity = optional(object({
      type = string
    }))

    private_endpoint = optional(object({
      subnet_id            = string
      private_dns_zone_ids = optional(list(string))
    }))
    tags = optional(map(string), null)
  })
}
