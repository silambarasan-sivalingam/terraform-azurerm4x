output "shared_image_gallery_id" {
  value       = azurerm_shared_image_gallery.this.id
  description = "The ID of the Shared Image Gallery."
}

output "shared_image_gallery_name" {
  value       = azurerm_shared_image_gallery.this.unique_name
  description = "The name of the Shared Image Gallery."
}

