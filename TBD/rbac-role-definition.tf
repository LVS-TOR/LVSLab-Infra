data "azurerm_role_definition" "global-contributor" {
  name = "Contributor"
}

data "azurerm_role_definition" "global-owner" {
  name = "Owner"
}

data "azurerm_role_definition" "network-contributor" {
  name = "Network Contributor"
}

data "azurerm_role_definition" "app-contributor" {
  name = "Managed Application Contributor Role"
}

data "azurerm_role_definition" "security-admin" {
  name = "Security Admin"
}

data "azurerm_role_definition" "billing-contributor" {
  name = "Cost Management Contributor"
}

data "azurerm_role_definition" "global-reader" {
  name = "Reader"
}

data "azurerm_role_definition" "vm-contributor" {
  name = "Virtual Machine Contributor"
}




resource "azurerm_role_assignment" "global-contributor" {
  for_each = local.mgmtgroups_map
  scope              = data.azurerm_management_group.mgmtgroup[each.key].id
  role_definition_id = data.azurerm_role_definition.global-contributor.id
  principal_id       = var.global-contributor
}

resource "azurerm_role_assignment" "global-owner" {
  for_each = local.mgmtgroups_map
  scope              = data.azurerm_management_group.mgmtgroup[each.key].id
  role_definition_id = data.azurerm_role_definition.global-owner.id
  principal_id       = var.global-owner
}

resource "azurerm_role_assignment" "app-contributor" {
  for_each = local.mgmtgroups_map
  scope              = data.azurerm_management_group.mgmtgroup[each.key].id
  role_definition_id = data.azurerm_role_definition.app-contributor.id
  principal_id       = var.app-contributor
}

resource "azurerm_role_assignment" "security-admin" {
  for_each = local.mgmtgroups_map
  scope              = data.azurerm_management_group.mgmtgroup[each.key].id
  role_definition_id = data.azurerm_role_definition.security-admin.id
  principal_id       = var.security-admin
}

resource "azurerm_role_assignment" "billing-contributor" {
  for_each = local.mgmtgroups_map
  scope              = data.azurerm_management_group.mgmtgroup[each.key].id
  role_definition_id = data.azurerm_role_definition.billing-contributor.id
  principal_id       = var.billing-contributor
}

resource "azurerm_role_assignment" "global-reader" {
  for_each = local.mgmtgroups_map
  scope              = data.azurerm_management_group.mgmtgroup[each.key].id
  role_definition_id = data.azurerm_role_definition.global-reader.id
  principal_id       = var.global-reader
}

resource "azurerm_role_assignment" "network-contributor" {
  for_each = local.mgmtgroups_map
  scope              = data.azurerm_management_group.mgmtgroup[each.key].id
  role_definition_id = data.azurerm_role_definition.network-contributor.id
  principal_id       = var.network-contributor
}



resource "azurerm_role_definition" "dba-contributor" {
  for_each = local.subscriptions_map

  name        = "SQL Database Contributor (Custom)"
  scope       = data.azurerm_subscription.subscription[each.key].id
  description = "This is a custom role created via Terraform"

  permissions {
    actions     = [
          "Microsoft.DocumentDB/*/read",
          "Microsoft.DocumentDB/databaseAccounts/readonlykeys/action",
          "Microsoft.Insights/MetricDefinitions/read",
          "Microsoft.Insights/Metrics/read",
          "Microsoft.Resources/subscriptions/resourceGroups/read",
          "Microsoft.Support/*",
          "Microsoft.Authorization/*/read",
          "Microsoft.Cache/register/action",
          "Microsoft.Cache/redis/*",
          "Microsoft.Insights/alertRules/*",
          "Microsoft.ResourceHealth/availabilityStatuses/read",
          "Microsoft.Resources/deployments/*",
          "Microsoft.Authorization/*/read",
          "Microsoft.Insights/metricAlerts/*",
          "Microsoft.Sql/locations/*/read",
          "Microsoft.Sql/servers/databases/*",
          "Microsoft.Sql/servers/read",
          "Microsoft.Support/*",
          "Microsoft.Network/networkSecurityGroups/*",
          "Microsoft.Network/routeTables/*",
          "Microsoft.Sql/managedInstances/*",
          "Microsoft.Network/virtualNetworks/subnets/*",
          "Microsoft.Network/virtualNetworks/*",
          "Microsoft.Sql/servers/*",

        ]
    not_actions = [
        "Microsoft.Sql/managedInstances/databases/currentSensitivityLabels/*",
        "Microsoft.Sql/managedInstances/databases/recommendedSensitivityLabels/*",
        "Microsoft.Sql/managedInstances/databases/schemas/tables/columns/sensitivityLabels/*",
        "Microsoft.Sql/managedInstances/databases/securityAlertPolicies/*",
        "Microsoft.Sql/managedInstances/databases/sensitivityLabels/*",
        "Microsoft.Sql/managedInstances/databases/vulnerabilityAssessments/*",
        "Microsoft.Sql/managedInstances/securityAlertPolicies/*",
        "Microsoft.Sql/managedInstances/vulnerabilityAssessments/*",
        #"Microsoft.Sql/servers/databases/auditingPolicies/*",
        "Microsoft.Sql/servers/databases/auditingSettings/*",
        "Microsoft.Sql/servers/databases/auditRecords/read",
        #"Microsoft.Sql/servers/databases/connectionPolicies/*",
        "Microsoft.Sql/servers/databases/currentSensitivityLabels/*",
        "Microsoft.Sql/servers/databases/dataMaskingPolicies/*",
        "Microsoft.Sql/servers/databases/extendedAuditingSettings/*",
        "Microsoft.Sql/servers/databases/recommendedSensitivityLabels/*",
        "Microsoft.Sql/servers/databases/schemas/tables/columns/sensitivityLabels/*",
        "Microsoft.Sql/servers/databases/securityAlertPolicies/*",
        "Microsoft.Sql/servers/databases/securityMetrics/*",
        "Microsoft.Sql/servers/databases/sensitivityLabels/*",
        "Microsoft.Sql/servers/databases/vulnerabilityAssessments/*",
        "Microsoft.Sql/servers/databases/vulnerabilityAssessmentScans/*",
        "Microsoft.Sql/servers/databases/vulnerabilityAssessmentSettings/*",
        "Microsoft.Sql/servers/vulnerabilityAssessments/*",
        ]
  }

  assignable_scopes = [
    data.azurerm_subscription.subscription[each.key].id,
  ]
}


resource "azurerm_role_assignment" "dba-contributor" {
  for_each = local.subscriptions_map
  
  scope              = data.azurerm_subscription.subscription[each.key].id
  role_definition_id = azurerm_role_definition.dba-contributor[each.key].id
  principal_id       = var.dba-contributor
}
