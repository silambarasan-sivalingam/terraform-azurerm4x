variable "settings" {
  description = "Network Security Group configuration."
  type = object({
    name                = string
    location            = string
    resource_group_name = string
    security_rule = optional(map(object({
      #name                                       = string
      description                                = optional(string)
      protocol                                   = string
      source_port_range                          = optional(string)
      source_port_ranges                         = optional(list(number))
      destination_port_range                     = optional(string)
      destination_port_ranges                    = optional(list(number))
      priority                                   = number
      direction                                  = string
      access                                     = string
      source_address_prefix                      = optional(string)
      source_address_prefixes                    = optional(list(string))
      source_application_security_group_ids      = optional(list(string), [])
      destination_address_prefix                 = optional(string)
      destination_address_prefixes               = optional(list(string))
      destination_application_security_group_ids = optional(list(string), [])
    })))
    # subnet_id = string
    tags = optional(map(string), null)
  })
}