variable "settings" {
  description = "private_dns_zone_virtual_network_link configuration."
  type = object({
    name                  = string
    resource_group_name   = string
    private_dns_zone_name = string
    virtual_network_id    = string
    registration_enabled  = optional(bool)

    tags = optional(map(string))

  })
}
