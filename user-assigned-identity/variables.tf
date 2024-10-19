variable "settings" {
  description = "User assigned identity configuration."
  type = object({
    name                = string
    location            = string
    resource_group_name = string
    tags                = optional(map(string), null)

    role_assignment = optional(list(object({
      scope                = string
      role_definition_name = string
    })))
  })
}
