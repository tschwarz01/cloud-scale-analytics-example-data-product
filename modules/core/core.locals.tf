locals {


  keyvaults = {

    dp01 = {
      name                      = "dp01"
      location                  = var.global_settings.location
      resource_group_key        = "data_product01"
      sku_name                  = "standard"
      enable_rbac_authorization = true
      soft_delete_enabled       = true
      purge_protection_enabled  = false

      diagnostic_profiles = {
        hivekv = {
          definition_key   = "azure_key_vault"
          destination_type = "log_analytics"
          destination_key  = "central_logs"
        }
      }

      private_endpoints = {
        vault = {
          name               = "dp01kv"
          resource_group_key = "data_product01"
          location           = var.global_settings.location
          vnet_key           = "vnet"
          subnet_key         = "private_endpoints"

          private_service_connection = {
            name                 = "dp01kv"
            is_manual_connection = false
            subresource_names    = ["vault"]
          }

          private_dns = {
            zone_group_name = "default"
            keys            = ["privatelink.vaultcore.azure.net"]
          }
        }
      }
    }
  }


  storage_accounts = {
    dp01_aml = {
      name                     = "dp01mlstg"
      resource_group_key       = "data_product01"
      location                 = var.global_settings.location
      account_replication_type = var.module_settings.adls_account_replication_type
      account_kind             = "StorageV2"
      account_tier             = "Standard"
      is_hns_enabled           = false
    }
    dp01_synapse = {
      name                     = "dp01synapse"
      resource_group_key       = "data_product01"
      location                 = var.global_settings.location
      account_kind             = "BlockBlobStorage"
      account_tier             = var.module_settings.adls_account_tier
      account_replication_type = var.module_settings.adls_account_replication_type
      is_hns_enabled           = true
    }
  }


  containers = {
    dp01 = {
      name        = "mlworkspace"
      storage_key = "dp01_aml"
    }
  }


  filesystems = {
    dp01 = {
      name        = "dp01synapsefs"
      storage_key = "dp01_synapse"
    }
  }


  app_insights = {
    dp01 = {
      name               = "dp01"
      resource_group_key = "data_product01"
      application_type   = "web"
      law_workspace_key  = "central_logs"
    }
  }


  azure_container_registries = {
    dp01 = {
      name                          = "acrdp01"
      resource_group_key            = "data_product01"
      sku                           = "Premium"
      quarantine_policy_enabled     = true
      public_network_access_enabled = false
      retention_policy = {
        days    = 7
        enabled = true
      }
      diagnostic_profiles = {
        operations = {
          name             = "acr_logs"
          definition_key   = "azure_container_registry"
          destination_type = "log_analytics"
          destination_key  = "central_logs"
        }
      }
    }
  }


  data_factory = {
    dp01 = {
      name                            = "dp01"
      resource_group_key              = "data_product01"
      managed_virtual_network_enabled = true
      enable_system_msi               = true

      diagnostic_profiles = {
        central_logs_region1 = {
          definition_key   = "azure_data_factory"
          destination_type = "log_analytics"
          destination_key  = "central_logs"
        }
      }

      private_endpoints = {
        dp01-factory = {
          name               = "adf-dp01-acct"
          subnet_key         = "private_endpoints"
          resource_group_key = "data_product01"

          private_service_connection = {
            name              = "adf-dp01-acct"
            subresource_names = ["dataFactory"]
          }

          private_dns = {
            zone_group_name = "default"
            keys            = ["privatelink.datafactory.azure.net"]
          }
        }
        dp01-portal = {
          name               = "adf-dp01-portal"
          subnet_key         = "private_endpoints"
          resource_group_key = "data_product01"

          private_service_connection = {
            name              = "adf-dp01-portal"
            subresource_names = ["portal"]
          }

          private_dns = {
            zone_group_name = "default"
            keys            = ["privatelink.adf.azure.com"]
          }
        }

      }
    }
  }


  private_endpoints = {

    ml_blob = {
      resource_id        = azurerm_storage_account.stg["dp01_aml"].id
      name               = "dp01-aml-stg-blob"
      subnet_key         = "private_endpoints"
      resource_group_key = "data_product01"

      private_service_connection = {
        name              = "dp01-aml-stg-blob"
        subresource_names = ["blob"]
      }

      private_dns = {
        zone_group_name = "default"
        keys            = ["privatelink.blob.core.windows.net"]
      }
    }
    ml_file = {
      resource_id        = azurerm_storage_account.stg["dp01_aml"].id
      name               = "dp01-aml-stg-file"
      subnet_key         = "private_endpoints"
      resource_group_key = "data_product01"

      private_service_connection = {
        name              = "dp01-aml-stg-file"
        subresource_names = ["file"]
      }

      private_dns = {
        zone_group_name = "default"
        keys            = ["privatelink.file.core.windows.net"]
      }
    }

    syn_blob = {
      resource_id        = azurerm_storage_account.stg["dp01_synapse"].id
      name               = "dp01-syn-stg-blob"
      subnet_key         = "private_endpoints"
      resource_group_key = "data_product01"

      private_service_connection = {
        name              = "dp01-syn-stg-blob"
        subresource_names = ["blob"]
      }

      private_dns = {
        zone_group_name = "default"
        keys            = ["privatelink.blob.core.windows.net"]
      }
    }
    syn_dfs = {
      resource_id        = azurerm_storage_account.stg["dp01_synapse"].id
      name               = "dp01-syn-stg-dfs"
      subnet_key         = "private_endpoints"
      resource_group_key = "data_product01"

      private_service_connection = {
        name              = "dp01-syn-stg-dfs"
        subresource_names = ["dfs"]
      }

      private_dns = {
        zone_group_name = "default"
        keys            = ["privatelink.dfs.core.windows.net"]
      }
    }

    acr = {
      resource_id        = azurerm_container_registry.acr["dp01"].id
      name               = "dmlz"
      resource_group_key = "data_product01"
      location           = var.global_settings.location
      subnet_key         = "private_endpoints"
      private_service_connection = {
        name                 = "acr0031"
        is_manual_connection = false
        subresource_names    = ["registry"]
      }
      private_dns = {
        zone_group_name = "privatelink.azurecr.io"
        keys            = ["privatelink.azurecr.io"]
      }
    }

  }

  role_assignments = {
    kvsyn = {
      scope                = module.keyvault["dp01"].id
      role_definition_name = "Key Vault Secrets Officer"
      principal_id         = var.global_settings.client_config.object_id
    }
  }


}
