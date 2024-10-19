<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_eventhub.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/eventhub) | resource |
| [azurerm_eventhub_namespace.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/eventhub_namespace) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_settings"></a> [settings](#input\_settings) | Event hub Configurations. | <pre>object({<br>    resource_group_name         = string<br>    location                    = string<br>    tags                        = optional(map(string), null)<br>    eventhub_namespace_name     = string<br>    eventhub_namespace_sku      = string<br>    eventhub_namespace_capacity = number<br>    azurerm_eventhub = list(object({<br>      name                       = optional(string, "default")<br>      eventhub_partition_count   = optional(number, 2)<br>      eventhub_message_retention = optional(number, 1)<br>    }))<br>  })</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_eventhub_id"></a> [eventhub\_id](#output\_eventhub\_id) | The ID of the EventHub. |
| <a name="output_namespace_id"></a> [namespace\_id](#output\_namespace\_id) | The EventHub Namespace ID. |
| <a name="output_namespace_name"></a> [namespace\_name](#output\_namespace\_name) | The EventHub Namespace name. |
<!-- END_TF_DOCS -->