variable "settings" {
  description = "All settings required for the Azure Shared Image Gallery"
  type = object({
    name                = string
    resource_group_name = string
    location            = string
    description         = optional(string)
    tags                = optional(map(string))
    sharing = optional(object({
      permission = string
      community_gallery = optional(object({
        eula            = string
        prefix          = string
        publisher_email = string
        publisher_uri   = string
      }))
    }))
  })
}