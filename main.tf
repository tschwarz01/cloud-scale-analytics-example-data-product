terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.7.0"
    }
  }
  required_version = ">= 0.15"

  backend "azurerm" {
    subscription_id      = "893395a4-65a3-4525-99ea-2378c6e0dbed"
    resource_group_name  = "rg-data-landing-zone-terraform"
    storage_account_name = "stgcafcsatfstate"
    container_name       = "caf-csa-example-data-product"
    key                  = "ex-data-product.terraform.tfstate"
  }

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
  backend = "azurerm"

  config = {
    subscription_id      = var.remote_state_subscription_id
    container_name       = var.remote_state_container_name
    resource_group_name  = var.remote_state_resource_group_name
    storage_account_name = var.remote_state_storage_account_name
    key                  = var.remote_state_tfstate_key
  }
}


resource "azurerm_resource_group" "rg" {
  for_each = local.resource_groups
  name     = lower("${random_string.prefix[0].result}-${var.environment}-${each.value.name}")
  location = each.value.location
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

