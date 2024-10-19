variable "settings" {
  description = "resource group configuration"

  type = object({
    name     = string
    location = string
    tags     = optional(map(string))
  })
}
