## Using it in a blueprint

IMPORTANT: We periodically release versions for the components. Since, master branch may have breaking changes, best practice would be to use a released version in form of a tag (e.g. ?ref=x.y.z)

```terraform
module "batch_pool" {
  for_each = local.configure_batch_pool.settings
  source   = "../../../../modules/Modules/batch_pool_2.0.0"
  settings = each.value
}
```

Sample value for settings.batch_pool.tf as below:

locals {
  configure_batch_pool = {
    settings = {
      bp-app-sbox-bu-aen-001 = {
        name     = "bp-app-sbox-bu-aen-001"
        resource_group_name = "rg-app-sbix-bu-aen-001"
        account_name        = azurerm_batch_account.example.name
        display_name        = "Test Acc Pool Auto"
        vm_size             = "Standard_A1"
        node_agent_sku_id   = "batch.node.ubuntu 20.04"

          auto_scale {
           evaluation_interval = "PT15M"

            formula = <<EOF
              startingNumberOfVMs = 1;
              maxNumberofVMs = 25;
              pendingTaskSamplePercent = $PendingTasks.GetSamplePercent(180 * TimeInterval_Second);
              pendingTaskSamples = pendingTaskSamplePercent < 70 ? startingNumberOfVMs : avg($PendingTasks.GetSample(180 *   TimeInterval_Second));
              $TargetDedicatedNodes=min(maxNumberofVMs, pendingTaskSamples);
            EOF
            }

              storage_image_reference {
                publisher = "microsoft-azure-batch"
                offer     = "ubuntu-server-container"
                sku       = "20-04-lts"
                version   = "latest"
              }

                container_configuration {
                  type = "DockerCompatible"
                  container_registries {
                    registry_server = "docker.io"
                    user_name       = "login"
                    password        = "apassword"
                  }
                }

                start_task {
                  command_line       = "echo 'Hello World from $env'"
                  task_retry_maximum = 1
                  wait_for_success   = true

                   common_environment_properties = {
                      env = "TEST"
                      }

                  user_identity {
                    auto_user {
                      elevation_level = "NonAdmin"
                      scope           = "Task"
                    }
                  }
                }

                  certificate {
                    id             = azurerm_batch_certificate.example.id
                    store_location = "CurrentUser"
                    visibility     = ["StartTask"]
                  }
                }
      }
    }
  }

