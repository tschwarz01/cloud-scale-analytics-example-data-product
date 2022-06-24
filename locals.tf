resource "random_string" "prefix" {
  count   = lookup(var.global_settings, "prefix", null) == null ? 1 : 0
  length  = 4
  special = false
  upper   = false
  numeric = false
}


locals {
  global_settings = {
    resource_group_name = azurerm_resource_group.rg["dp01"].name
    location            = var.location
    prefix              = random_string.prefix[0].result
    environment         = var.environment
    name                = lower("${random_string.prefix[0].result}-${var.environment}")
    name_clean          = lower("${random_string.prefix[0].result}${var.environment}")
    tags                = merge(local.base_tags, var.tags, {})
    client_config = {
      client_id               = data.azurerm_client_config.default.client_id
      tenant_id               = data.azurerm_client_config.default.tenant_id
      subscription_id         = data.azurerm_subscription.current.id
      object_id               = data.azurerm_client_config.default.object_id
      logged_user_objectId    = data.azurerm_client_config.default.object_id
      logged_aad_app_objectId = data.azurerm_client_config.default.object_id
    }
  }

  base_tags = {
    Solution = "CAF Cloud Scale Analytics"
    Project  = "Example Data Product"
    Toolkit  = "Terraform"
  }

  resource_groups = {
    dp01 = {
      name     = "data_product001"
      location = var.location
    }
  }

  remote_objects = data.terraform_remote_state.dlz.outputs

  combined_objects_core = {
    diagnostics             = merge(local.combined_diagnostics, local.remote_objects.combined_objects_core.diagnostics, {})
    resource_groups         = merge(local.remote_objects.combined_objects_core.resource_groups, {})
    virtual_networks        = merge(local.remote_objects.combined_objects_core.virtual_networks, {})
    virtual_subnets         = merge(local.remote_objects.combined_objects_core.virtual_subnets, {})
    network_security_groups = merge(local.remote_objects.combined_objects_core.network_security_groups, {})
    private_dns_zones       = local.remote_objects.combined_objects_core.private_dns_zones
  }


  analytics_module_settings = {
    adls_account_tier             = var.adls_account_tier
    adls_account_replication_type = var.adls_account_replication_type
    synapse_sql_pool_sku          = var.synapse_sql_pool_sku
    synapse_spark_node_size       = var.synapse_spark_node_size
    synapse_spark_min_node_count  = var.synapse_spark_min_node_count
    synapse_spark_max_node_count  = var.synapse_spark_max_node_count
    feature_flags = {
      create_sql_pool   = var.deploy_synapse_sql_pool == true ? true : false
      create_spark_pool = var.deploy_synapse_spark_pool == true ? true : false
    }
  }


  advanced_analytics_module_settings = {
    synapse_spark_pools           = module.data-product-analytics.synapse_spark_pools
    adls_account_replication_type = var.adls_account_replication_type
    gen2_filesystems              = local.gen2_filesystems
  }

  operations_module_settings = {
    data_factories     = module.data-product-analytics.data_factories
    synapse_workspaces = module.data-product-analytics.synapse_workspaces
    diagnostics        = local.combined_diagnostics
  }


  diagnostics_destinations = {
    log_analytics = {
      central_logs = {
        workspace_id              = var.remote_log_analytics_workspace_workspace_id != null ? var.remote_log_analytics_workspace_workspace_id : data.terraform_remote_state.dlz.outputs.combined_objects_core.diagnostics.diagnostics_destinations.log_analytics["central_logs"].workspace_id
        log_analytics_resource_id = var.remote_log_analytics_workspace_resource_id != null ? var.remote_log_analytics_workspace_resource_id : data.terraform_remote_state.dlz.outputs.combined_objects_core.diagnostics.diagnostics_destinations.log_analytics["central_logs"].log_analytics_resource_id
      }
    }
  }


  combined_diagnostics = {
    diagnostics_definition   = try(local.remote_objects.combined_objects_core.diagnostics.diagnostics_definition, local.diagnostics_definition)
    diagnostics_destinations = local.diagnostics_destinations
  }


  gen2_filesystems = {
    shared_synaspe = {
      storage_account_key = "workspace"
      resource_id         = format("%s/blobServices/default/containers/%s", local.remote_objects.datalake_services.gen2_filesystems["shared_synaspe"].storage_account_id, local.remote_objects.datalake_services.gen2_filesystems["shared_synaspe"].name)
    }
    sandbox = {
      storage_account_key = "workspace"
      resource_id         = format("%s/blobServices/default/containers/%s", local.remote_objects.datalake_services.gen2_filesystems["sandbox"].storage_account_id, local.remote_objects.datalake_services.gen2_filesystems["sandbox"].name)
    }
    landing = {
      storage_account_key = "raw"
      resource_id         = format("%s/blobServices/default/containers/%s", local.remote_objects.datalake_services.gen2_filesystems["landing"].storage_account_id, local.remote_objects.datalake_services.gen2_filesystems["landing"].name)
    }
    conformance = {
      storage_account_key = "raw"
      resource_id         = format("%s/blobServices/default/containers/%s", local.remote_objects.datalake_services.gen2_filesystems["conformance"].storage_account_id, local.remote_objects.datalake_services.gen2_filesystems["conformance"].name)
    }
    enriched = {
      storage_account_key = "curated"
      resource_id         = format("%s/blobServices/default/containers/%s", local.remote_objects.datalake_services.gen2_filesystems["enriched"].storage_account_id, local.remote_objects.datalake_services.gen2_filesystems["enriched"].name)
    }
    curated = {
      storage_account_key = "curated"
      resource_id         = format("%s/blobServices/default/containers/%s", local.remote_objects.datalake_services.gen2_filesystems["curated"].storage_account_id, local.remote_objects.datalake_services.gen2_filesystems["curated"].name)
    }
    dp01 = {
      storage_account_key = "dp01_synapse"
      resource_id         = format("%s/blobServices/default/containers/%s", module.data-product-analytics.gen2_filesystems["dp01"].storage_account_id, module.data-product-analytics.gen2_filesystems["dp01"].name)
    }
  }


}
