output "synapse_workspaces" {
  value = azurerm_synapse_workspace.ws
}


output "synapse_sql_pools" {
  value = azurerm_synapse_sql_pool.sql_pool
}


output "synapse_spark_pools" {
  value = azurerm_synapse_spark_pool.spark_pool
}


output "private_endpoints" {
  value = module.private_endpoints
}


output "keyvaults" {
  value = module.keyvault
}


output "gen2_filesystems" {
  value = azurerm_storage_data_lake_gen2_filesystem.gen2
}


output "storage_accounts" {
  value = azurerm_storage_account.stg
}


output "data_factories" {
  value = module.data_factory
}
