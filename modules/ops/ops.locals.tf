locals {


  action_groups = {
    main = {
      name               = "pipeline-action-group"
      resource_group_key = "data_product01"
      short_name         = "email-group"
      enabled            = true

      email_receiver = {
        name                    = "sendtodevops"
        email_address           = "thosch@microsoft.com"
        use_common_alert_schema = true
      }
    }
  }


  metric_alerts = {
    adf_pipeline = {
      name                 = "adf-pipeline-failure"
      resource_group_key   = "data_product01"
      description          = "ADF pipeline failed"
      scopes               = var.module_settings.data_factories["dp01"].id
      auto_mitigate        = false
      frequency            = "PT1M"
      severity             = 1
      target_resource_type = "Microsoft.DataFactory/factories"
      window_size          = "PT1M"

      action = {
        action_group_key = "main"
      }

      criteria = {
        metric_namespace = "Microsoft.DataFactory/factories"
        metric_name      = "PipelineFailedRuns"
        aggregation      = "Total"
        operator         = "GreaterThanOrEqual"
        threshold        = 1
      }
    }
    synapse_pipeline = {
      name                 = "synapse-pipeline-failure"
      resource_group_key   = "data_product01"
      description          = "Synapse pipeline failed"
      scopes               = var.module_settings.synapse_workspaces["dp01"].id
      auto_mitigate        = false
      frequency            = "PT1M"
      severity             = 1
      target_resource_type = "Microsoft.Synapse/workspaces"
      window_size          = "PT1M"

      action = {
        action_group_key = "main"
      }

      criteria = {
        metric_namespace = "Microsoft.Synapse/workspaces"
        metric_name      = "IntegrationPipelineRunsEnded"
        aggregation      = "Total"
        operator         = "GreaterThanOrEqual"
        threshold        = 1
      }
    }
  }


  dashboards = {
    adf = {
      name               = "adf-pipeline-executions"
      resource_group_key = "data_product01"

      dashboard_properties = {
        data_factory_key = "dp01"
      }
    }
  }

}
