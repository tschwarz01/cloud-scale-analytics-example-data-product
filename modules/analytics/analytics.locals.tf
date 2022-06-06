locals {

  synapse_workspaces = {
    dp01 = {
      name                    = "syn-dp01-ws"
      resource_group_key      = "data_product01"
      sql_administrator_login = "dbadmin"
      gen2_filesystem_id      = var.module_settings.gen2_filesystems["dp01"].id
      # sql_administrator_login_password = "<string password>"   # If not set use module autogenerate a strong password and stores it in the keyvault
      keyvault_key                    = "dp01"
      managed_virtual_network_enabled = true
      data_encrypted                  = true

      aad_admin = {
        login     = "thosch@microsoft.com"
        object_id = var.global_settings.client_config.object_id
        tenant_id = var.global_settings.client_config.tenant_id
      }

      sql_aad_admin = {
        login     = "thosch@microsoft.com"
        object_id = var.global_settings.client_config.object_id
        tenant_id = var.global_settings.client_config.tenant_id
      }

      diagnostic_profiles = {
        synapsews = {
          definition_key   = "synapse_workspace"
          destination_type = "log_analytics"
          destination_key  = "central_logs"
        }
      }
    }
  }

  synapse_sql_pools = {
    dp01_pool = {
      name                  = "dp01"
      synapse_workspace_key = "dp01"
      sku_name              = var.module_settings.synapse_sql_pool_sku
      create_mode           = "Default"

      diagnostic_profiles = {
        synapse_sql = {
          definition_key   = "synapse_sql_pool"
          destination_type = "log_analytics"
          destination_key  = "central_logs"
        }
      }
    }
  }


  synapse_spark_pools = {
    dp01 = {
      name                  = "dp01spark" #[name can contain only letters or numbers, must start with a letter, and be between 1 and 15 characters long]
      synapse_workspace_key = "dp01"
      node_size_family      = "MemoryOptimized" # Only current option
      node_size             = var.module_settings.synapse_spark_node_size
      cache_size            = 20 # Percentage of disk to reserve for cache
      spark_version         = "3.1"

      auto_scale = {
        max_node_count = var.module_settings.synapse_spark_max_node_count
        min_node_count = var.module_settings.synapse_spark_min_node_count
      }

      auto_pause = {
        delay_in_minutes = 15
      }

      diagnostic_profiles = {
        synapse_spark = {
          definition_key   = "synapse_spark_pool"
          destination_type = "log_analytics"
          destination_key  = "central_logs"
        }
      }
    }
  }


  private_endpoints = {

    sql = {
      resource_id        = azurerm_synapse_workspace.ws["dp01"].id
      name               = "dp01synapsesql"
      vnet_key           = "vnet"
      subnet_key         = "private_endpoints"
      resource_group_key = "data_product01"

      private_service_connection = {
        name                 = "dp01synapsesql"
        is_manual_connection = false
        subresource_names    = ["Sql"]
      }

      private_dns = {
        zone_group_name = "default"
        keys            = ["privatelink.sql.azuresynapse.net"]
      }
    }

    sqlod = {
      resource_id        = azurerm_synapse_workspace.ws["dp01"].id
      name               = "dp01synapsesqlod"
      vnet_key           = "vnet"
      subnet_key         = "private_endpoints"
      resource_group_key = "data_product01"

      private_service_connection = {
        name                 = "dp01synapsesqlod"
        is_manual_connection = false
        subresource_names    = ["SqlOnDemand"]
      }

      private_dns = {
        zone_group_name = "default"
        keys            = ["privatelink.sql.azuresynapse.net"]
      }
    }

    dev = {
      resource_id        = azurerm_synapse_workspace.ws["dp01"].id
      name               = "dp01synapsedev"
      vnet_key           = "vnet"
      subnet_key         = "private_endpoints"
      resource_group_key = "data_product01"

      private_service_connection = {
        name                 = "dp01synapsedev"
        is_manual_connection = false
        subresource_names    = ["Dev"]
      }

      private_dns = {
        zone_group_name = "default"
        keys            = ["privatelink.dev.azuresynapse.net"]
      }
    }
  }

}
