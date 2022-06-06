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
