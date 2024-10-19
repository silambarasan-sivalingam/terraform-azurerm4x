variable "settings" {
  description = "UDR configuration."
  type = object({
    name                          = string
    location                      = string
    resource_group_name           = string
    disable_bgp_route_propagation = optional(bool)

    route = optional(list(object({
      name                   = string
      address_prefix         = string
      next_hop_type          = string
      next_hop_in_ip_address = optional(string, null)
    })))
    tags = optional(map(string), null)

    subnets = optional(list(object({
      subnet_id = string
    })))


  })
}
