##### Generate random password #######
resource "random_password" "this" {
  length           = 21
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "azurerm_linux_virtual_machine" "this" {
  name                            = var.settings.name
  resource_group_name             = var.settings.resource_group_name
  location                        = var.settings.location
  size                            = var.settings.size
  admin_username                  = var.settings.admin_username
  admin_password                  = random_password.this.result
  disable_password_authentication = var.settings.disable_password_authentication
  encryption_at_host_enabled      = true
  zone                            = var.settings.zone



  availability_set_id   = var.settings.availability_set_id == null ? null : var.settings.availability_set_id
  network_interface_ids = [azurerm_network_interface.this.id]
  license_type          = var.settings.license_type
  computer_name         = var.settings.computer_name == null ? var.settings.name : var.settings.computer_name
  tags                  = var.settings.tags
  depends_on            = [azurerm_network_interface.this]

  os_disk {
    name                      = var.settings.os_disk.name
    caching                   = var.settings.os_disk.caching
    storage_account_type      = var.settings.os_disk.storage_account_type
    disk_size_gb              = var.settings.os_disk.disk_size_gb
    write_accelerator_enabled = var.settings.os_disk.write_accelerator_enabled
    disk_encryption_set_id    = var.settings.disk_encryption_set_id
  }

  source_image_reference {
    publisher = var.settings.source_image_reference.publisher
    offer     = var.settings.source_image_reference.offer
    sku       = var.settings.source_image_reference.sku
    version   = var.settings.source_image_reference.version
  }
  dynamic "plan" {
    for_each = var.settings.plan != null ? var.settings.plan : []
    content {
      name      = plan.value.name
      product   = plan.value.product
      publisher = plan.value.publisher
    }
  }

  dynamic "additional_capabilities" {
    for_each = var.settings.additional_capabilities != null ? [var.settings.additional_capabilities] : []
    content {
      ultra_ssd_enabled = var.settings.additional_capabilities.ultra_ssd_enabled
    }
  }


  dynamic "identity" {
    for_each = var.settings.identity != null ? [var.settings.identity] : []
    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }

  dynamic "admin_ssh_key" {
    for_each = var.settings.admin_ssh_key != null ? [var.settings.admin_ssh_key] : []
    content {
      username   = admin_ssh_key.value.username
      public_key = admin_ssh_key.value.public_key
    }
  }
}

resource "azurerm_network_interface" "this" {
  name                          = var.settings.network_interface.name
  location                      = var.settings.location
  resource_group_name           = var.settings.resource_group_name
  enable_accelerated_networking = var.settings.network_interface.enable_accelerated_networking
  enable_ip_forwarding          = false

  ip_configuration {
    name                          = "${var.settings.name}-ipconfig"
    subnet_id                     = var.settings.network_interface.ip_configuration.subnet_id
    private_ip_address_allocation = var.settings.network_interface.ip_configuration.private_ip_address_allocation
    private_ip_address            = var.settings.network_interface.ip_configuration.private_ip_address
    primary                       = var.settings.network_interface.ip_configuration.primary
  }
  tags = var.settings.tags
}
resource "azurerm_managed_disk" "this" {
  for_each               = try({ for md in var.settings.data_disk : md.name => md }, {})
  name                   = each.key
  location               = var.settings.location
  zone                   = var.settings.zone
  resource_group_name    = var.settings.resource_group_name
  storage_account_type   = each.value.storage_account_type
  create_option          = each.value.create_option
  disk_size_gb           = each.value.disk_size_gb
  disk_encryption_set_id = var.settings.disk_encryption_set_id
  tags                   = var.settings.tags

  lifecycle {
    ignore_changes = [network_access_policy]
  }

  depends_on = [azurerm_linux_virtual_machine.this]
}

resource "azurerm_virtual_machine_data_disk_attachment" "this" {
  for_each           = try({ for md in var.settings.data_disk : md.name => md }, {})
  managed_disk_id    = azurerm_managed_disk.this[each.key].id
  virtual_machine_id = azurerm_linux_virtual_machine.this.id
  lun                = each.value.lun
  caching            = each.value.caching
  create_option      = "Attach"

  depends_on = [azurerm_managed_disk.this]
}

resource "azurerm_key_vault_secret" "this" {
  for_each        = try({ for n in var.settings.key_vault_secret : n.name => n }, {})
  name            = each.key
  value           = random_password.this.result
  key_vault_id    = each.value.key_vault_id
  tags            = var.settings.tags
  expiration_date = "2026-12-31T00:00:00Z"

}

resource "azurerm_virtual_machine_extension" "this" {
  for_each                    = try({ for n in var.settings.virtual_machine_extension : n.name => n }, {})
  name                        = each.key
  virtual_machine_id          = azurerm_linux_virtual_machine.this.id
  publisher                   = each.value.publisher
  type                        = each.value.type
  type_handler_version        = each.value.type_handler_version
  auto_upgrade_minor_version  = each.value.auto_upgrade_minor_version
  automatic_upgrade_enabled   = each.value.automatic_upgrade_enabled
  settings                    = each.value.settings
  failure_suppression_enabled = each.value.failure_suppression_enabled
  protected_settings          = each.value.protected_settings
  provision_after_extensions  = each.value.provision_after_extensions
  tags                        = var.settings.tags

  dynamic "protected_settings_from_key_vault" {
    for_each = each.value.protected_settings_from_key_vault != null ? [each.value.protected_settings_from_key_vault] : []
    content {
      secret_url      = protected_settings_from_key_vault.value.secret_url
      source_vault_id = protected_settings_from_key_vault.value.source_vault_id
    }
  }
}
