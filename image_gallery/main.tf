resource "azurerm_shared_image_gallery" "this" {
  name                = var.settings.name
  resource_group_name = var.settings.resource_group_name
  location            = var.settings.location

  description = var.settings.description != null ? var.settings.description : ""

  tags = var.settings.tags != null ? var.settings.tags : {}

  dynamic "sharing" {
    for_each = var.settings.sharing != null ? [var.settings.sharing] : []
    content {
      permission = sharing.value.permission
      community_gallery {
        eula            = sharing.value.community_gallery.eula
        prefix          = sharing.value.community_gallery.prefix
        publisher_email = sharing.value.community_gallery.publisher_email
        publisher_uri   = sharing.value.community_gallery.publisher_uri
      }
    }
  }
}