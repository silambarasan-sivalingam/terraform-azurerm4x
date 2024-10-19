variable "settings" {
  description = "VNET configuration."
  type = object({
    name                = string
    location            = string
    resource_group_name = string
    address_space       = list(string)
    dns_servers         = optional(list(string))

    subnets = list(object({
      name              = string
      address_prefix    = string
      security_group    = optional(string)
      service_endpoints = optional(list(string), [])
      delegations = optional(list(object({
        name         = string
        service_name = string
        actions      = optional(list(string))
      })), [])
    }))

    tags = optional(map(string))
  })
}