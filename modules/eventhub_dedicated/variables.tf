variable "settings" {
  description = "azurerm_eventhub_cluster configuration."
  type = object({
    name                = string
    location            = string
    resource_group_name = string
    sku_name            = string
    tags                = optional(map(string))
  })
}
