
resource "azurerm_monitor_action_group" "action_group" {
  for_each            = local.action_groups
  name                = each.value.name
  resource_group_name = var.global_settings.resource_group_name
  short_name          = each.value.short_name
  enabled             = each.value.enabled
  tags                = var.tags

  email_receiver {
    name                    = each.value.email_receiver.name
    email_address           = each.value.email_receiver.email_address
    use_common_alert_schema = each.value.email_receiver.use_common_alert_schema
  }
}


resource "azurerm_monitor_metric_alert" "alerts" {
  for_each             = local.metric_alerts
  name                 = each.value.name
  resource_group_name  = var.global_settings.resource_group_name
  description          = each.value.description
  scopes               = [each.value.scopes]
  auto_mitigate        = each.value.auto_mitigate
  frequency            = each.value.frequency
  severity             = each.value.severity
  target_resource_type = each.value.target_resource_type
  window_size          = each.value.window_size
  tags                 = var.tags

  criteria {
    metric_namespace = each.value.criteria.metric_namespace
    metric_name      = each.value.criteria.metric_name
    aggregation      = each.value.criteria.aggregation
    operator         = each.value.criteria.operator
    threshold        = each.value.criteria.threshold
  }

  action {
    action_group_id = azurerm_monitor_action_group.action_group[each.value.action.action_group_key].id
  }
}


resource "azurerm_portal_dashboard" "test" {
  name                = "my-test-dashboard"
  resource_group_name = var.global_settings.resource_group_name
  location            = var.global_settings.location
  dashboard_properties = templatefile("${path.module}/dashboards/adf_pipeline_mon.tpl", {
    data_factory_scope = var.module_settings.data_factories["dp01"].id
    data_factory_name  = var.module_settings.data_factories["dp01"].name
  })
}



