variable "global_settings" {
  default = {}
}

variable "location" {
  description = "The location of the resource group"
  type        = string
}

variable "environment" {
  description = "The release stage of the environment"
  default     = "dev"
  type        = string
}

variable "tags" {
  description = "Tags that should be applied to all deployed resources"
  type        = map(string)
}

variable "prefix" {
  default = null
  type    = string
}

variable "data_product_resource_group_name" {
  type        = string
  description = "The resource group name (existing), deployed in the CSA Data Landing Zone, where the example data product resources created by this template should be deployed."
  default     = null
}

variable "data_product_virtual_subnet_id" {
  type    = string
  default = null
}

variable "synapse_ws_adls_storage_account_id" {
  type        = string
  description = "Resource id of the storage account provisioned for use by Synapse workspaces."
  default     = null
}

variable "synapse_ws_adls_filesystem_name" {
  type        = string
  description = "Name of the storage account filesystem provisioned for use by the example data product Synapse workspace."
  default     = null
}

variable "remote_log_analytics_workspace_resource_id" {
  type        = string
  description = "The resource_id of the remotely hosted Log Analytics Workspace where diagnostic logs should be sent."
  default     = null
}

variable "remote_log_analytics_workspace_workspace_id" {
  type        = string
  description = "The workspace_id of the remotely hosted Log Analytics Workspace where diagnostic logs should be sent."
  default     = null
}


variable "synapse_sql_pool_sku" {
  type        = string
  description = "The SKU for the Synapse dedicated SQL Pool, if deployed."
  default     = "DW500c"
  validation {
    condition     = can(regex("DW100c|DW200c|DW300c|DW400c|DW500c|DW1000c|DW1500c|DW2000c|DW2500c|DW3000c|DW5000c|DW6000c|DW7500c|DW10000c|DW15000c|DW30000c", var.synapse_sql_pool_sku))
    error_message = "Err: Valid options are 'DW100c', 'DW200c', 'DW300c', 'DW400c', 'DW500c', 'DW1000c', 'DW1500c', 'DW2000c', 'DW2500c', 'DW3000c', 'DW5000c', 'DW6000c', 'DW7500c', 'DW10000c', 'DW15000c', 'DW30000c'."
  }
}
variable "synapse_spark_node_size" {
  type        = string
  description = "The size of the virtual machines used within the Spark pool."
  default     = "Small"

  validation {
    condition     = can(regex("Small|Medium|Large|XLarge|XXLarge", var.synapse_spark_node_size))
    error_message = "Err: Valid options are 'Small', 'Medium', 'Large', 'XLarge', 'XXLarge'."
  }
}
variable "synapse_spark_min_node_count" {
  type        = number
  description = "The minimum number of Spark nodes to deploy when using Autoscale.  Minimum is 3."
  default     = 3
}
variable "synapse_spark_max_node_count" {
  type        = number
  description = "The maximum number of Spark nodes to deploy when using Autoscale.  Maximum is 200."
  default     = 5
}

variable "deploy_synapse_sql_pool" {
  type        = bool
  description = "Feature flag which determines if a shared Synapse Analytics sql pool will be deployed."
  default     = true
}

variable "deploy_synapse_spark_pool" {
  type        = bool
  description = "Feature flag which determines if a shared Synapse Analytics spark pool will be deployed."
  default     = true
}

variable "adls_account_tier" {
  type        = string
  description = "Storage account tier option for the data lake storage accounts"
  default     = "Standard"

  validation {
    condition     = contains(["Standard", "Premium"], var.adls_account_tier)
    error_message = "Invalid input, options: \"Standard\", \"Premium\"."
  }
}

variable "adls_account_replication_type" {
  type        = string
  description = "Storage replication option for the data lake storage accounts"
  default     = "ZRS"

  validation {
    condition     = contains(["LRS", "ZRS"], var.adls_account_replication_type)
    error_message = "Invalid input, options: \"LRS\", \"ZRS\"."
  }
}
