
output "keyvaults" {
  value = module.keyvault
}


output "gen2_filesystems" {
  value = azurerm_storage_data_lake_gen2_filesystem.gen2
}


output "container_registries" {
  value = azurerm_container_registry.acr
}


output "storage_accounts" {
  value = azurerm_storage_account.stg
}


output "application_insights" {
  value = azurerm_application_insights.appinsights
}


output "storage_containers" {
  value = azurerm_storage_container.container
}


output "data_factories" {
  value = module.data_factory
}


output "private_endpoints" {
  value = module.private_endpoints
}


