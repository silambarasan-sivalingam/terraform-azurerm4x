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
| [azurerm_public_ip.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_settings"></a> [settings](#input\_settings) | Public IP configuration. | <pre>object({<br>    name                    = string<br>    location                = string<br>    resource_group_name     = string<br>    allocation_method       = optional(string, "Static")<br>    zones                   = optional(list(string), [])<br>    sku                     = optional(string, "Standard")<br>    ddos_protection_mode    = optional(string, "VirtualNetworkInherited")<br>    ddos_protection_plan_id = optional(string, null)<br>    tags                 = optional(map(string), null)<br>  })</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID of this Public IP. |
| <a name="output_ip_address"></a> [ip\_address](#output\_ip\_address) | The IP address value that was allocated. |
<!-- END_TF_DOCS -->