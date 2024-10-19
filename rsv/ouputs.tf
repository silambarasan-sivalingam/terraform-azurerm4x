output "id" {
  description = "Created Storage Account properties."
  value       = azurerm_recovery_services_vault.this.id
}

output "backup_policy_vm_ids" {
  value = {
    for policy_name, policy_id in azurerm_backup_policy_vm.this :
    policy_name => policy_id.id
  }
  description = "Map of backup_policy_vm to their IDs."
}