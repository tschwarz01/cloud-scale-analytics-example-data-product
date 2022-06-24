
module "private_endpoint" {
  source   = "../../../networking/private_endpoint"
  for_each = var.settings.private_endpoints

  location = coalesce(lookup(each.value, "location", var.global_settings.location))
  #resource_group_name        = coalesce(lookup(each.value, "resource_group_name", null), lookup(each.value, "resource_group_key", null), var.global_settings.resource_group_name)
  resource_group_name        = var.global_settings.resource_group_name
  resource_id                = azurerm_key_vault.kv.id
  name                       = "${var.global_settings.name}-${each.value.name}"
  private_service_connection = each.value.private_service_connection
  subnet_id                  = can(each.value.subnet_id) ? each.value.subnet_id : var.combined_objects_core.virtual_subnets[each.value.subnet_key].id
  private_dns                = each.value.private_dns
  private_dns_zones          = var.combined_objects_core.private_dns_zones
  tags                       = var.tags
}
