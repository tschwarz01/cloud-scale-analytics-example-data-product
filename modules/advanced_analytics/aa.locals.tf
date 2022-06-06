locals {


  cognitive_services_account = {
    cv_train = {
      resource_group_key = "data_product01"
      name               = "dp01-cv-train"
      kind               = "CustomVision.Training"
      sku_name           = "F0"
    }
    cv_predict = {
      resource_group_key = "data_product01"
      name               = "dp01-cv-predict"
      kind               = "CustomVision.Prediction"
      sku_name           = "F0"
    }
  }

  search_service = {
    search01 = {
      name                          = "dp01-search"
      resource_group_key            = "data_product01"
      sku                           = "standard"
      partition_count               = 1
      replica_count                 = 1
      public_network_access_enabled = false
    }
  }


  aml_workspaces = {
    dp01 = {
      name                                         = "dp01"
      resource_group_key                           = "data_product01"
      application_insights_key                     = "dp01"
      keyvault_key                                 = "dp01"
      storage_account_key                          = "dp01_aml"
      container_registry_key                       = "dp01"
      sku_name                                     = "Basic"
      description                                  = "Example data product ml workspace"
      friendly_name                                = "dp01mlws"
      public_access_behind_virtual_network_enabled = false
      image_build_compute_name                     = "aml-image-builder"
    }
  }


  aml_computer_clusters = {}
  # aml_computer_clusters = {
  #   dp01 = {
  #     name              = "dp01-cluster"
  #     vm_priority       = "LowPriority"
  #     vm_size           = "STANDARD_D4AS_V4"
  #     aml_workspace_key = "dp01"
  #     subnet_key        = "aml_training"

  #     min_node_count                       = 0
  #     max_node_count                       = 3
  #     scale_down_nodes_after_idle_duration = "PT2M"
  #   }
  # }


  aml_links = {}
  # aml_links = {
  #   dp01 = {
  #     name                   = "dp01"
  #     aml_workspace_key      = "dp01"
  #     synapse_spark_pool_key = "dp01"
  #   }
  # }


  private_endpoints = {

    cogsvc01 = {
      resource_id        = azurerm_cognitive_account.cs["cv_predict"].id
      name               = "predict-acct01"
      subnet_key         = "private_endpoints"
      resource_group_key = "data_product01"

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
      resource_id           = azurerm_cognitive_account.cs["cv_train"].id
      name                  = "train-acct01"
      subnet_key            = "private_endpoints"
      resource_group_key    = "data_product01"
      custom_subdomain_name = "azlab.io"

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
      resource_id        = azurerm_search_service.search["search01"].id
      name               = "search-acct01"
      subnet_key         = "private_endpoints"
      resource_group_key = "data_product01"

      private_service_connection = {
        name              = "search-acct01"
        subresource_names = ["searchService"]
      }

      private_dns = {
        zone_group_name = "default"
        keys            = ["privatelink.search.windows.net"]
      }
    }

    ml_ws = {
      resource_id        = azurerm_machine_learning_workspace.aml-ws["dp01"].id
      name               = "dp01-mlws"
      subnet_key         = "private_endpoints"
      resource_group_key = "data_product01"

      private_service_connection = {
        name              = "dp01-mlws"
        subresource_names = ["amlworkspace"]
      }

      private_dns = {
        zone_group_name = "default"
        keys            = ["privatelink.api.azureml.ms", "privatelink.notebooks.azure.net"]
      }
    }
  }


  role_assignments = {
    amlacr = {
      scope                = var.module_settings.container_registries["dp01"].id
      role_definition_name = "AcrPull"
      principal_id         = azurerm_machine_learning_workspace.aml-ws["dp01"].identity[0].principal_id
    }
    # amldfscurated = {
    #   scope                = var.module_settings.gen2_filesystems["curated"].resource_id
    #   role_definition_name = "Storage Blob Data Reader"
    #   principal_id         = azurerm_machine_learning_workspace.aml-ws["dp01"].identity[0].principal_id
    # }
    # amldfsenriched = {
    #   scope                = var.module_settings.gen2_filesystems["enriched"].resource_id
    #   role_definition_name = "Storage Blob Data Reader"
    #   principal_id         = azurerm_machine_learning_workspace.aml-ws["dp01"].identity[0].principal_id
    # }
    # amldfssynapsews = {
    #   scope                = var.module_settings.gen2_filesystems["dp01"].resource_id
    #   role_definition_name = "Storage Blob Data Contributor"
    #   principal_id         = azurerm_machine_learning_workspace.aml-ws["dp01"].identity[0].principal_id
    # }
  }
}
