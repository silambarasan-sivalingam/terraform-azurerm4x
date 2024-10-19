variable "settings" {
  description = "Public IP prefix."
  type = object({
    name                = string
    location            = string
    resource_group_name = string
    prefix_length       = number
    zones               = optional(list(string))
    tags                = optional(map(string))
  })
}
