locals {

  keyvaults = {

    dp01_aml = {
      name                      = "dp01aml"
      location                  = var.global_settings.location
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
          name       = "dp01amlkv"
          location   = var.global_settings.location
          subnet_key = "private_endpoints"

          private_service_connection = {
            name                 = "dp01amlkv"
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


  app_insights = {
    dp01 = {
      name              = "dp01"
      application_type  = "web"
      law_workspace_key = "central_logs"
    }
  }


  azure_container_registries = {
    dp01 = {
      name                          = "acrdp01"
      sku                           = "Premium"
      quarantine_policy_enabled     = true
      public_network_access_enabled = false
      admin_enabled                 = true

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


  storage_accounts = {
    dp01_aml = {
      name                     = "dp01mlstg"
      location                 = var.global_settings.location
      account_replication_type = var.module_settings.adls_account_replication_type
      account_kind             = "StorageV2"
      account_tier             = "Standard"
      is_hns_enabled           = false
    }
  }


  containers = {
    dp01 = {
      name        = "mlworkspace"
      storage_key = "dp01_aml"
    }
  }


  cognitive_services_account = {
    cv_train = {
      name     = "dp01-cv-train"
      kind     = "CustomVision.Training"
      sku_name = "F0"
    }
    cv_predict = {
      name     = "dp01-cv-predict"
      kind     = "CustomVision.Prediction"
      sku_name = "F0"
    }
  }


  search_service = {
    search01 = {
      name                          = "dp01-search"
      sku                           = "standard"
      partition_count               = 1
      replica_count                 = 1
      public_network_access_enabled = false
    }
  }


  aml_workspaces = {
    dp01 = {
      name                                         = "dp01"
      application_insights_key                     = "dp01"
      keyvault_key                                 = "dp01_aml"
      storage_account_key                          = "dp01_aml"
      container_registry_key                       = "dp01"
      sku_name                                     = "Basic"
      description                                  = "Example data product ml workspace"
      friendly_name                                = "dp01mlws"
      admin_enabled                                = true
      public_access_behind_virtual_network_enabled = true
      public_network_access_enabled                = false
      image_build_compute_name                     = "aml-image-builder"
    }
  }


  #aml_computer_clusters = {}
  aml_computer_clusters = {
    dp01 = {
      name              = "dp01-cluster"
      vm_priority       = "LowPriority"
      vm_size           = "STANDARD_D4AS_V4"
      aml_workspace_key = "dp01"
      subnet_key        = "aml_training"

      min_node_count                       = 0
      max_node_count                       = 3
      scale_down_nodes_after_idle_duration = "PT2M"
    }
  }


  #aml_links = {}
  aml_links = {
    dp01 = {
      name                   = "dp01"
      aml_workspace_key      = "dp01"
      synapse_spark_pool_key = "dp01"
    }
  }


  private_endpoints = {

    cogsvc01 = {
      resource_id = azurerm_cognitive_account.cs["cv_predict"].id
      name        = "predict-acct01"
      subnet_key  = "private_endpoints"

      private_service_connection = {
        name              = "predict-acct01"
        subresource_names = ["account"]
      }

      private_dns = {
        zone_group_name = "default"
        keys            = ["privatelink.cognitiveservices.azure.com"]
      }
    }

    cogsvc02 = {
      resource_id = azurerm_cognitive_account.cs["cv_train"].id
      name        = "train-acct01"
      subnet_key  = "private_endpoints"

      private_service_connection = {
        name              = "train-acct01"
        subresource_names = ["account"]
      }

      private_dns = {
        zone_group_name = "default"
        keys            = ["privatelink.cognitiveservices.azure.com"]
      }
    }

    search = {
      resource_id = azurerm_search_service.search["search01"].id
      name        = "search-acct01"
      subnet_key  = "private_endpoints"

      private_service_connection = {
        name              = "search-acct01"
        subresource_names = ["searchService"]
      }

      private_dns = {
        zone_group_name = "default"
        keys            = ["privatelink.search.windows.net"]
      }
    }

    acr = {
      resource_id = azurerm_container_registry.acr["dp01"].id
      name        = "dmlz"
      subnet_key  = "private_endpoints"

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

    ml_ws = {
      resource_id = azurerm_machine_learning_workspace.aml-ws["dp01"].id
      name        = "dp01-mlws"
      subnet_key  = "private_endpoints"

      private_service_connection = {
        name              = "dp01-mlws"
        subresource_names = ["amlworkspace"]
      }

      private_dns = {
        zone_group_name = "default"
        keys            = ["privatelink.api.azureml.ms", "privatelink.notebooks.azure.net"]
      }
    }

    ml_blob = {
      resource_id = azurerm_storage_account.stg["dp01_aml"].id
      name        = "dp01-aml-stg-blob"
      subnet_key  = "private_endpoints"

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
      resource_id = azurerm_storage_account.stg["dp01_aml"].id
      name        = "dp01-aml-stg-file"
      subnet_key  = "private_endpoints"

      private_service_connection = {
        name              = "dp01-aml-stg-file"
        subresource_names = ["file"]
      }

      private_dns = {
        zone_group_name = "default"
        keys            = ["privatelink.file.core.windows.net"]
      }
    }
  }


  role_assignments = {
    amlacr = {
      scope                = azurerm_container_registry.acr["dp01"].id
      role_definition_name = "AcrPull"
      principal_id         = azurerm_machine_learning_workspace.aml-ws["dp01"].identity[0].principal_id
    }
    amldfscurated = {
      scope                = var.module_settings.gen2_filesystems["curated"].resource_id
      role_definition_name = "Storage Blob Data Reader"
      principal_id         = azurerm_machine_learning_workspace.aml-ws["dp01"].identity[0].principal_id
    }
    amldfsenriched = {
      scope                = var.module_settings.gen2_filesystems["enriched"].resource_id
      role_definition_name = "Storage Blob Data Reader"
      principal_id         = azurerm_machine_learning_workspace.aml-ws["dp01"].identity[0].principal_id
    }
    amldfssynapsews = {
      scope                = var.module_settings.gen2_filesystems["dp01"].resource_id
      role_definition_name = "Storage Blob Data Contributor"
      principal_id         = azurerm_machine_learning_workspace.aml-ws["dp01"].identity[0].principal_id
    }
  }
}
