variable "settings" {
  description = "configure nat gateway resources"
  type = object({
    location                = string
    resource_group_name     = string
    name                    = string
    sku_name                = optional(string)
    idle_timeout_in_minutes = optional(number)
    zones                   = optional(list(string))
    tags                    = optional(map(string))


    nat_gateway_public_ip_association = optional(list(object({
      public_ip_address_id = string
    })))

    nat_gateway_public_ip_prefix_association = optional(list(object({
      public_ip_prefix_id = string
    })))

    subnet_nat_gateway_association = optional(list(object({
      subnet_id = string
    })))
  })

  #   validation {
  #   condition     = contains(["az", "aw", "gb", "gc"], var.settings.location)
  #   error_message = "(Required, String) Valid values:\n  az, aws, gb, gc for cloud_provider."
  # }
}
