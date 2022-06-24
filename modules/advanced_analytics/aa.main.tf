
module "keyvault" {
  source   = "../../services/general/keyvault/keyvault"
  for_each = local.keyvaults

  global_settings       = var.global_settings
  settings              = each.value
  location              = var.global_settings.location
  resource_group_name   = var.global_settings.resource_group_name
  name                  = "${var.global_settings.name}-${each.value.name}"
  tags                  = var.tags
  combined_objects_core = var.combined_objects_core
}


resource "azurerm_application_insights" "appinsights" {
  for_each = local.app_insights

  name                                = "${var.global_settings.name}-${each.value.name}"
  resource_group_name                 = var.global_settings.resource_group_name
  location                            = var.global_settings.location
  workspace_id                        = var.combined_objects_core.diagnostics.diagnostics_destinations.log_analytics[each.value.law_workspace_key].log_analytics_resource_id
  application_type                    = each.value.application_type
  local_authentication_disabled       = false
  disable_ip_masking                  = false
  force_customer_storage_for_profiler = false
  retention_in_days                   = 30
  internet_query_enabled              = false
  internet_ingestion_enabled          = true
  tags                                = var.tags
}


resource "azurerm_container_registry" "acr" {
  for_each = local.azure_container_registries

  name                          = "${var.global_settings.name_clean}${each.value.name}"
  resource_group_name           = var.global_settings.resource_group_name
  location                      = var.global_settings.location
  sku                           = each.value.sku
  admin_enabled                 = lookup(each.value, "admin_enabled", false)
  quarantine_policy_enabled     = lookup(each.value, "quarantine_policy_enabled", false)
  public_network_access_enabled = lookup(each.value, "public_network_access_enabled", true)

  identity {
    type = "SystemAssigned"
  }

  dynamic "retention_policy" {
    for_each = lookup(each.value, "retention_policy", null) == null ? [] : [each.value.retention_policy]

    content {
      days    = lookup(retention_policy.value, "days", null)
      enabled = lookup(retention_policy.value, "enabled", true)
    }
  }
}


resource "azurerm_storage_account" "stg" {
  for_each = local.storage_accounts

  name                            = "${var.global_settings.name_clean}${each.value.name}"
  resource_group_name             = var.global_settings.resource_group_name
  location                        = var.global_settings.location
  account_kind                    = lookup(each.value, "account_kind", "StorageV2")
  account_tier                    = lookup(each.value, "account_tier", "Standard")
  account_replication_type        = lookup(each.value, "account_replication_type", "GRS")
  min_tls_version                 = "TLS1_2"
  allow_nested_items_to_be_public = false
  is_hns_enabled                  = lookup(each.value, "is_hns_enabled", false)
  tags                            = var.tags
}


resource "azurerm_storage_container" "container" {
  for_each = local.containers

  name                 = each.value.name
  storage_account_name = azurerm_storage_account.stg[each.value.storage_key].name
}


resource "azurerm_cognitive_account" "cs" {
  for_each = local.cognitive_services_account

  name                  = "${var.global_settings.name}-${each.value.name}"
  location              = var.global_settings.location
  resource_group_name   = var.global_settings.resource_group_name
  kind                  = lookup(each.value, "kind")
  sku_name              = lookup(each.value, "sku_name")
  custom_subdomain_name = "${var.global_settings.name}-${each.value.name}"
  tags                  = var.tags
}


resource "azurerm_search_service" "search" {
  for_each = local.search_service

  name                          = "${var.global_settings.name}-${each.value.name}"
  resource_group_name           = var.global_settings.resource_group_name
  location                      = var.global_settings.location
  sku                           = lookup(each.value, "sku", "standard")
  partition_count               = lookup(each.value, "partition_count", 1)
  replica_count                 = lookup(each.value, "replica_count", 1)
  public_network_access_enabled = lookup(each.value, "public_network_access_enabled", true)
}


resource "azurerm_machine_learning_workspace" "aml-ws" {
  for_each = local.aml_workspaces

  name                                         = "${var.global_settings.name}-${each.value.name}"
  location                                     = var.global_settings.location
  resource_group_name                          = var.global_settings.resource_group_name
  application_insights_id                      = azurerm_application_insights.appinsights[each.value.application_insights_key].id
  container_registry_id                        = azurerm_container_registry.acr[each.value.container_registry_key].id
  storage_account_id                           = azurerm_storage_account.stg[each.value.storage_account_key].id
  key_vault_id                                 = module.keyvault[each.value.keyvault_key].id
  sku_name                                     = lookup(each.value, "sku_name", null)
  description                                  = lookup(each.value, "description", null)
  friendly_name                                = lookup(each.value, "friendly_name", null)
  image_build_compute_name                     = lookup(each.value, "image_build_compute_name", "aml-image-builder")
  public_access_behind_virtual_network_enabled = lookup(each.value, "public_access_behind_virtual_network_enabled", true)
  tags                                         = var.tags

  identity {
    type = "SystemAssigned"
  }
}


resource "azurerm_machine_learning_compute_cluster" "aml-cluster" {
  for_each = try(local.aml_computer_clusters, {})

  name                          = "${var.global_settings.name}-${each.value.name}"
  location                      = var.global_settings.location
  vm_priority                   = each.value.vm_priority
  vm_size                       = each.value.vm_size
  machine_learning_workspace_id = azurerm_machine_learning_workspace.aml-ws[each.value.aml_workspace_key].id
  subnet_resource_id            = var.combined_objects_core.virtual_subnets[each.value.subnet_key].id
  local_auth_enabled            = false
  ssh_public_access_enabled     = false
  tags                          = var.tags

  scale_settings {
    min_node_count                       = each.value.min_node_count
    max_node_count                       = each.value.max_node_count
    scale_down_nodes_after_idle_duration = each.value.scale_down_nodes_after_idle_duration
  }

  identity {
    type = "SystemAssigned"
  }
}


resource "azurerm_machine_learning_synapse_spark" "aml-syn" {
  for_each = try(local.aml_links, {})

  name                          = "${var.global_settings.name}-${each.value.name}"
  machine_learning_workspace_id = azurerm_machine_learning_workspace.aml-ws[each.value.aml_workspace_key].id
  location                      = var.global_settings.location
  synapse_spark_pool_id         = var.module_settings.synapse_spark_pools[each.value.synapse_spark_pool_key].id

  identity {
    type = "SystemAssigned"
  }
}


module "private_endpoints" {
  source   = "../../services/networking/private_endpoint"
  for_each = local.private_endpoints

  location                   = lookup(each.value, "location", var.global_settings.location)
  resource_group_name        = var.global_settings.resource_group_name
  resource_id                = each.value.resource_id
  name                       = "${var.global_settings.name}-${each.value.name}"
  private_service_connection = each.value.private_service_connection
  subnet_id                  = lookup(each.value, "subnet_id", var.combined_objects_core.virtual_subnets[each.value.subnet_key].id)
  private_dns                = each.value.private_dns
  private_dns_zones          = var.combined_objects_core.private_dns_zones
  tags                       = var.tags
}


resource "azurerm_role_assignment" "role_assignment" {
  for_each = local.role_assignments

  scope                = each.value.scope
  role_definition_name = each.value.role_definition_name
  principal_id         = each.value.principal_id
}
