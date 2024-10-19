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
| [azurerm_network_security_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_subnet_network_security_group_association.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_settings"></a> [settings](#input\_settings) | Network Security Group configuration. | <pre>object({<br>    name                = string<br>    location            = string<br>    resource_group_name = string<br>    security_rule = optional(list(object({<br>      name                                       = string<br>      description                                = optional(string)<br>      protocol                                   = string<br>      source_port_range                          = optional(string)<br>      source_port_ranges                         = optional(list(number))<br>      destination_port_range                     = optional(string)<br>      destination_port_ranges                    = optional(list(number))<br>      priority                                   = number<br>      direction                                  = string<br>      access                                     = string<br>      source_address_prefix                      = optional(string)<br>      source_address_prefixes                    = optional(list(string))<br>      source_application_security_group_ids      = optional(list(string), [])<br>      destination_address_prefix                 = optional(string)<br>      destination_address_prefixes               = optional(list(string))<br>      destination_application_security_group_ids = optional(list(string), [])<br>    })))<br>    subnet_id = string<br>    tags      = optional(map(string), null)<br>  })</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_nsg_id"></a> [nsg\_id](#output\_nsg\_id) | The id of the Network Security Croup created. |
<!-- END_TF_DOCS -->