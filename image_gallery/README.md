# Azure Shared Image Gallery
This Terraform module provisions an Azure Shared Image Gallery with configurable sharing profiles and community gallery features. It allows for a highly customizable setup to manage shared images across different Azure subscriptions or within a community.

## Usage
To use this module in your Terraform configuration, follow these steps:

Define the Module Source: Specify the path or repository where this module is located.

Configure Required Variables: At a minimum, you need to provide values for name, resource_group_name, and location. Other settings are optional and can be customized as needed.

Call the Module: Incorporate the module into your Terraform configuration using the module block.

Example

```
module "shared_image_gallery" {
  source = "./modules/shared_image_gallery" # Adjust the path according to your directory structure

  settings = {
    name                = "mySharedImageGallery"
    resource_group_name = "myResourceGroup"
    location            = "UAE North"
    description         = "A shared image gallery for distributing images."
    tags                = {
      Environment = "Production"
    }
    sharing = {
      permission = "Reader"
      community_gallery = {
        eula            = "EULA text here"
        prefix          = "myprefix"
        publisher_email = "email@example.com"
        publisher_uri   = "https://example.com"
      }
    }
  }
}
```
## Variables
- name: (Required) The name of the Shared Image Gallery.
- resource_group_name: (Required) The name of the resource group in which to create the Shared Image Gallery.
- location: (Required) The location/region where the Shared Image Gallery is created.
- description: (Optional) A description for the Shared Image Gallery.
- unique_name: (Optional) A boolean flag to indicate if the name should be unique across Azure. Defaults to false.
- tags: (Optional) A map of tags to assign to the resource.
- sharing_profile: (Optional) A configuration block for sharing profiles.
- community_gallery: (Optional) A configuration block to enable or disable the community gallery feature.





