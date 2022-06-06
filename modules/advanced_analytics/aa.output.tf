
output "cognitive_accounts" {
  value = azurerm_cognitive_account.cs
}


output "cognitive_search" {
  value = azurerm_search_service.search
}


output "aml_workspaces" {
  value = azurerm_machine_learning_workspace.aml-ws
}


output "aml_compute_cluster" {
  value = try(azurerm_machine_learning_compute_cluster.aml-cluster, null)
}


output "aml_spark" {
  value = try(azurerm_machine_learning_synapse_spark.aml-syn, null)
}


output "private_endpoints" {
  value = module.private_endpoints
}
