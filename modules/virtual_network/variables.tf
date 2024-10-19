variable "settings" {
  type = object({
    name                = string
    resource_group_name = string
    location            = string
    address_space       = list(string)
    dns_servers         = optional(list(string))

    subnets = optional(list(object({
      name                                          = string
      address_prefixes                              = string
      security_group                                = optional(string)
      default_outbound_access_enabled               = optional(bool)
      private_endpoint_network_policies             = optional(bool)
      private_link_service_network_policies_enabled = optional(bool)
      route_table_id                                = optional(string)
      service_endpoints                             = optional(list(string))

      delegation = optional(list(object({
        name                = string
        service_delegations = optional(list(object({
          name    = string
          actions = list(string)
        })))
      })))
    })))

    ddos_protection_plan = optional(object({
      id     = string
      enable = bool
    }))

    encryption = optional(object({
      enforcement = string
    }))

    tags = optional(map(string))
  })
}