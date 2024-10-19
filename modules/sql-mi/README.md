Refer below sample tfvars :

```
settings = {
  name                = "sqlmi-demo-m42"
  location            = "UAE North"
  resource_group_name = "rg-keyvault"
  administrator_login = "demoadmin"
  subnet_id           = "/subscriptions/6062df96-ecc3-4efc-a9be-bd78220e56ca/resourceGroups/rg-keyvault/providers/Microsoft.Network/virtualNetworks/tf-virnetwork-test-001/subnets/test1"
  key_vault_key_id    = "https://akv-sbx-test-002.vault.azure.net/keys/cmk-des-sb-aen-001/14d37663d803494bb70df951a3c0f225"
  vcores              = 4
  license_type        = "BasePrice"
  sku_name            = "GP_Gen5"
  storage_size_in_gb  = 32
  license_type        = "BasePrice"
  key_vault_id        = "/subscriptions/6062df96-ecc3-4efc-a9be-bd78220e56ca/resourceGroups/rg-keyvault/providers/Microsoft.KeyVault/vaults/akv-sbx-test-002"

  identity = {
    type         = "UserAssigned"
    identity_ids = ["/subscriptions/6062df96-ecc3-4efc-a9be-bd78220e56ca/resourceGroups/rg-keyvault/providers/Microsoft.ManagedIdentity/userAssignedIdentities/mi-acr"]
  }
}

```