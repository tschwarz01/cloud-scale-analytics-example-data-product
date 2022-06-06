terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.7.0"
    }
  }
  required_version = ">= 0.15"
  #experiments      = [module_variable_optional_attrs]
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = true
    }
    log_analytics_workspace {
      permanently_delete_on_destroy = true
    }
    resource_group {
      prevent_deletion_if_contains_resources = true
    }
    template_deployment {
      delete_nested_items_during_deletion = true
    }
  }
}

data "azurerm_client_config" "default" {}
data "azuread_client_config" "current" {}
data "azurerm_subscription" "current" {}

data "terraform_remote_state" "dlz" {
  backend = "local"

  config = {
    path = "../caf-csa-landing-zone/terraform.tfstate"
  }
}


resource "azurerm_resource_group" "rg" {
  name     = lower("${random_string.prefix[0].result}-${var.environment}-data_product0001")
  location = local.global_settings.location
}


module "data-product-core" {
  depends_on = [ azurerm_resource_group.rg ]
  source                = "./modules/core"
  global_settings       = local.global_settings
  module_settings       = local.core_module_settings
  combined_objects_core = local.combined_objects_core
  remote                = local.remote_objects
  tags                  = local.global_settings.tags
}


module "data-product-analytics" {
  source                = "./modules/analytics"
  global_settings       = local.global_settings
  module_settings       = local.analytics_module_settings
  combined_objects_core = local.combined_objects_core
  remote                = local.remote_objects
  tags                  = local.global_settings.tags
}


module "data-product-advanced-analytics" {
  source                = "./modules/advanced_analytics"
  global_settings       = local.global_settings
  module_settings       = local.advanced_analytics_module_settings
  combined_objects_core = local.combined_objects_core
  remote                = local.remote_objects
  tags                  = local.global_settings.tags
}


module "data-product-operations" {
  source                = "./modules/ops"
  global_settings       = local.global_settings
  module_settings       = local.operations_module_settings
  combined_objects_core = local.combined_objects_core
  remote                = local.remote_objects
  tags                  = local.global_settings.tags
}


output "gs" {
  value = local.global_settings.client_config
}
