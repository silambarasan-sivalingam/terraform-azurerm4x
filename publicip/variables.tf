variable "settings" {
  description = "Public IP configuration."
  type = object({
    name                    = string
    location                = string
    resource_group_name     = string
    allocation_method       = optional(string)
    zones                   = optional(list(string))
    sku                     = optional(string)
    ddos_protection_mode    = optional(string)
    ddos_protection_plan_id = optional(string)
    domain_name_label       = optional(string)
    ip_tags                 = optional(map(string))
    tags                    = optional(map(string))
  })
}
