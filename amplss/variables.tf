variable "settings" {
  description = "App Service Plan configuration."
  type = object({
    name                = string
    scope_name          = string
    resource_group_name = string
    linked_resource_id  = string
  })
}
