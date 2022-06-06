#########################################
##          General Settings
#########################################
location    = "southcentralus"
environment = "dev"
tags = {
  Org = "Cloud Ops"
}


#########################################
##      Datalake Storage Settings
#########################################
adls_account_tier             = "Premium"
adls_account_replication_type = "LRS"


#########################################
##      Diagnostics Settings
#########################################
remote_log_analytics_workspace_resource_id  = null
remote_log_analytics_workspace_workspace_id = null

#remote_log_analytics_workspace_resource_id  = "/subscriptions/47f7e6d7-0e52-4394-92cb-5f106bbc647f/resourceGroups/tpaa-dev-logging-and-monitoring/providers/Microsoft.OperationalInsights/workspaces/tpaa-dev-logs"
#remote_log_analytics_workspace_workspace_id = "f83cc9b8-e3d7-4af4-b3da-b5b3290f2bf9"

#########################################
##      Required Data Product Settings
#########################################
deploy_synapse_sql_pool      = false
deploy_synapse_spark_pool    = true
synapse_sql_pool_sku         = "DW100c"
synapse_spark_min_node_count = 3
synapse_spark_max_node_count = 50




