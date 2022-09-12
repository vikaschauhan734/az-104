#Automation Account
resource "azurerm_automation_account" "myaa" {
  name                = "my-automation-account"
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
  sku_name            = "Basic"
}

#Log Analytics Workspace
resource "azurerm_log_analytics_workspace" "mylaw" {
  name                = "workspace-01"
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

#Log Analytics Linked Service
resource "azurerm_log_analytics_linked_service" "mylals" {
  resource_group_name = azurerm_resource_group.myrg.name
  workspace_id        = azurerm_log_analytics_workspace.mylaw.id
  read_access_id      = azurerm_automation_account.myaa.id
}

#Log Analytics Solution
resource "azurerm_log_analytics_solution" "mylasu" {
  solution_name         = "Updates"
  location              = azurerm_resource_group.myrg.location
  resource_group_name   = azurerm_resource_group.myrg.name
  workspace_resource_id = azurerm_log_analytics_workspace.mylaw.id
  workspace_name        = azurerm_log_analytics_workspace.mylaw.name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/Updates"
  }
}

#Log Analytics Solution
resource "azurerm_log_analytics_solution" "mylasct" {
  solution_name         = "ChangeTracking"
  location              = azurerm_resource_group.myrg.location
  resource_group_name   = azurerm_resource_group.myrg.name
  workspace_resource_id = azurerm_log_analytics_workspace.mylaw.id
  workspace_name        = azurerm_log_analytics_workspace.mylaw.name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/ChangeTracking"
  }
}

# Send logs to Log Analytics
# Required for automation account with update management and/or change tracking enabled.
# Optional on automation accounts used of other purposes.
resource "azurerm_monitor_diagnostic_setting" "aa_diags_logs" {
  name = "LogsToLogAnalytics"
  target_resource_id = azurerm_automation_account.myaa.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.mylaw.id

  log {
    category = "JobLogs"
    enabled  = true

    retention_policy {
      enabled = false
    }
  }

  log {
    category = "JobStreams"
    enabled  = true

    retention_policy {
      enabled = false
    }
  }

  log {
    category = "DscNodeStatus"
    enabled  = true

    retention_policy {
      enabled = false
    }
  }

  metric {
    category = "AllMetrics"
    enabled = false

    retention_policy {
      enabled = false
    }
  }
}


# Send metrics to Log Analytics
resource "azurerm_monitor_diagnostic_setting" "aa_diags_metrics" {
  name                       = "MetricsToLogAnalytics"
  target_resource_id         = azurerm_automation_account.myaa.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.mylaw.id

    log {
    category = "JobLogs"
    enabled  = false

    retention_policy {
      enabled = false
    }
  }

  log {
    category = "JobStreams"
    enabled  = false

    retention_policy {
      enabled = false
    }
  }

  log {
    category = "DscNodeStatus"
    enabled  = false

    retention_policy {
      enabled = false
    }
  }

  metric {
    category = "AllMetrics"
    enabled = true

    retention_policy {
      enabled = false
    }
  }
}