module "keyvault" {
  source   = "../../services/general/keyvault/keyvault"
  for_each = local.keyvaults

  global_settings       = var.global_settings
  settings              = each.value
  location              = var.global_settings.location
  resource_group_name   = var.remote.combined_objects_core.resource_groups[each.value.resource_group_key].name
  name                  = "${var.global_settings.name}-${each.value.name}"
  tags                  = var.tags
  combined_objects_core = var.combined_objects_core
}


resource "azurerm_storage_account" "stg" {
  for_each = local.storage_accounts

  name                            = "${var.global_settings.name_clean}${each.value.name}"
  resource_group_name             = var.global_settings.resource_group_name
  location                        = var.global_settings.location
  account_kind                    = each.value.account_kind
  account_tier                    = each.value.account_tier
  account_replication_type        = each.value.account_replication_type
  min_tls_version                 = "TLS1_2"
  allow_nested_items_to_be_public = false
  is_hns_enabled                  = each.value.is_hns_enabled
  tags                            = try(var.tags, {})
}


resource "azurerm_storage_data_lake_gen2_filesystem" "gen2" {
  for_each = local.filesystems

  name               = each.value.name
  storage_account_id = azurerm_storage_account.stg[each.value.storage_key].id
}


resource "azurerm_storage_container" "container" {
  for_each = local.containers

  name                 = each.value.name
  storage_account_name = azurerm_storage_account.stg[each.value.storage_key].name
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
  tags                                = try(var.tags, {})

}


resource "azurerm_container_registry" "acr" {
  for_each = local.azure_container_registries

  name                          = "${var.global_settings.name_clean}${each.value.name}"
  resource_group_name           = var.global_settings.resource_group_name
  location                      = var.global_settings.location
  sku                           = each.value.sku
  admin_enabled                 = try(each.value.admin_enabled, false)
  quarantine_policy_enabled     = try(each.value.quarantine_policy_enabled, false)
  public_network_access_enabled = try(each.value.public_network_access_enabled, true)

  identity {
    type = "SystemAssigned"
  }

  dynamic "retention_policy" {
    for_each = try(each.value.retention_policy, null) == null ? [] : [each.value.retention_policy]

    content {
      days    = lookup(retention_policy.value, "days", null)
      enabled = lookup(retention_policy.value, "enabled", true)
    }
  }
}


module "data_factory" {
  source   = "../../services/general/data_factory/data_factory"
  for_each = local.data_factory

  name                  = "${var.global_settings.name}-${each.value.name}"
  global_settings       = var.global_settings
  settings              = each.value
  location              = var.global_settings.location
  resource_group_name   = var.global_settings.resource_group_name
  combined_objects_core = var.combined_objects_core
  tags                  = var.tags
}


module "private_endpoints" {
  source   = "../../services/networking/private_endpoint"
  for_each = local.private_endpoints

  location                   = try(each.value.location, var.global_settings.location, null)
  resource_group_name        = try(each.value.resource_group_name, var.combined_objects_core.resource_groups[try(each.value.resource_group.key, each.value.resource_group_key)].name)
  resource_id                = each.value.resource_id
  name                       = "${var.global_settings.name}-${each.value.name}"
  private_service_connection = each.value.private_service_connection
  subnet_id                  = try(each.value.subnet_id, var.combined_objects_core.virtual_subnets[each.value.subnet_key].id)
  private_dns                = each.value.private_dns
  private_dns_zones          = var.combined_objects_core.private_dns_zones
  tags                       = try(var.tags, {})
}


resource "azurerm_role_assignment" "role_assignment" {
  depends_on = [module.keyvault]
  for_each   = local.role_assignments

  scope                = each.value.scope
  role_definition_name = each.value.role_definition_name
  principal_id         = each.value.principal_id
}
