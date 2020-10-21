data "azurerm_policy_definition" "allowed-locations" {
  display_name = "Allowed locations"
}


resource "azurerm_policy_assignment" "allowed-locations" {
  for_each = local.mgmtgroups_map
  name                 = "AllowedLocations"
  scope                = data.azurerm_management_group.mgmtgroup[each.key].id
  policy_definition_id = data.azurerm_policy_definition.allowed-locations.id
  description          = "Policy Assignment created via an Acceptance Test"
  display_name         = "Allowed locations"

  parameters = jsonencode({
    listOfAllowedLocations = {
      value = var.locations
    }
  })

}

######################################

data "azurerm_policy_definition" "match-location" {
  display_name = "Audit resource location matches resource group location"
}

resource "azurerm_policy_assignment" "match-location" {
  for_each = local.mgmtgroups_map
  name                 = "AuditLocMatchRG"
  scope                = data.azurerm_management_group.mgmtgroup[each.key].id
  policy_definition_id = data.azurerm_policy_definition.match-location.id
  description          = "Policy Assignment created via an Acceptance Test"
  display_name         = "Audit resource location matches resource group location"
  not_scopes           = ["/subscriptions/d46cacf7-02b5-49b9-8fcc-33bac24c7a10/resourceGroups/NetworkWatcherRG","/subscriptions/c6aa20dd-fc19-4860-8c2d-a7d8d94fd87e/resourceGroups/NetworkWatcherRG", "/subscriptions/3dae562e-7b7d-48e3-adef-d65a43afc4c4/resourceGroups/NetworkWatcherRG"]
}

#################################################################################### Custom subscription owner roles should not exist

data "azurerm_policy_definition" "no-custom-owner" {
  display_name = "Custom subscription owner roles should not exist"
}

resource "azurerm_policy_assignment" "no-custom-owner" {
  for_each = local.mgmtgroups_map
  name                 = "AuditCustomOwner"
  scope                = data.azurerm_management_group.mgmtgroup[each.key].id
  policy_definition_id = data.azurerm_policy_definition.no-custom-owner.id
  description          = "Policy Assignment created via an Acceptance Test"
  display_name         = "Custom subscription owner roles should not exist"

}

####################################################################################### Unattached disks should be encrypted

data "azurerm_policy_definition" "unattached-encrypt" {
  display_name = "Unattached disks should be encrypted"
}

resource "azurerm_policy_assignment" "unattached-encrypt" {
  for_each = local.mgmtgroups_map
  name                 = "AuditUnAttchDisksEncrypt"
  scope                = data.azurerm_management_group.mgmtgroup[each.key].id
  policy_definition_id = data.azurerm_policy_definition.unattached-encrypt.id
  description          = "Policy Assignment created via an Acceptance Test"
  display_name         = "Unattached disks should be encrypted"

}


########################################################################### Key Vault should use a virtual network service endpoint

data "azurerm_policy_definition" "kvaultservendpoint" {
  display_name = "Key Vault should use a virtual network service endpoint"
}

resource "azurerm_policy_assignment" "kvaultservendpoint" {
  for_each = local.mgmtgroups_map
  name                 = "KeyVaultServiceEndpoint"
  scope                = data.azurerm_management_group.mgmtgroup[each.key].id
  policy_definition_id = data.azurerm_policy_definition.kvaultservendpoint.id
  description          = "Policy Assignment created via an Acceptance Test"
  display_name         = "Key Vault should use a virtual network service endpoint"

}


########################################################################### Network interfaces should not have public IPs

data "azurerm_policy_definition" "nopublicip" {
  display_name = "Network interfaces should not have public IPs"
}

resource "azurerm_policy_assignment" "nopublicip" {
  for_each = local.mgmtgroups_map
  name                 = "NoPublicIP"
  scope                = data.azurerm_management_group.mgmtgroup[each.key].id
  policy_definition_id = data.azurerm_policy_definition.nopublicip.id
  description          = "Policy Assignment created via an Acceptance Test"
  display_name         = "Network interfaces should not have public IPs"

}

########################################################################### Storage Accounts should use a virtual network service endpoint

data "azurerm_policy_definition" "saservendpoint" {
  display_name = "Storage Accounts should use a virtual network service endpoint"
}

resource "azurerm_policy_assignment" "saservendpoint" {
  for_each = local.mgmtgroups_map
  name                 = "SAServiceEndpoint"
  scope                = data.azurerm_management_group.mgmtgroup[each.key].id
  policy_definition_id = data.azurerm_policy_definition.saservendpoint.id
  description          = "Policy Assignment created via an Acceptance Test"
  display_name         = "Storage Accounts should use a virtual network service endpoint"

}
########################################################################### SQL Server should use a virtual network service endpoint

data "azurerm_policy_definition" "sqlservendpoint" {
  display_name = "SQL Server should use a virtual network service endpoint"
}

resource "azurerm_policy_assignment" "sqlservendpoint" {
  for_each = local.mgmtgroups_map
  name                 = "SQLServiceEndpoint"
  scope                = data.azurerm_management_group.mgmtgroup[each.key].id
  policy_definition_id = data.azurerm_policy_definition.sqlservendpoint.id
  description          = "Policy Assignment created via an Acceptance Test"
  display_name         = "SQL Server should use a virtual network service endpoint"

}

########################################################################### Network interfaces should disable IP forwarding

data "azurerm_policy_definition" "auditipforwarding" {
  display_name = "Network interfaces should disable IP forwarding"
}

resource "azurerm_policy_assignment" "auditipforwarding" {
  for_each = local.mgmtgroups_map
  name                 = "AuditIPForwarding"
  scope                = data.azurerm_management_group.mgmtgroup[each.key].id
  policy_definition_id = data.azurerm_policy_definition.auditipforwarding.id
  description          = "Policy Assignment created via an Acceptance Test"
  display_name         = "Network interfaces should disable IP forwarding"

}

########################################################################### Require a tag on resource groups

data "azurerm_policy_definition" "requiretags" {
  display_name = "Require a tag on resource groups"
}


resource "azurerm_policy_assignment" "requiretags" {
  for_each = local.mgmtgroups_map
  name                 = "RequireTags"
  scope                = data.azurerm_management_group.mgmtgroup[each.key].id
  policy_definition_id = data.azurerm_policy_definition.requiretags.id
  description          = "Policy Assignment created via an Acceptance Test"
  display_name         = "Require a tag on resource groups"

  parameters = jsonencode({
    tagName = {
      value = "Environment"
    }
  })

}

/*

########################################################################### Inherit a tag from the resource group

data "azurerm_policy_definition" "inherit-rgtags" {
  display_name = "Inherit a tag from the resource group"
}

resource "azurerm_policy_assignment" "inherit-rgtags" {
  for_each = local.mgmtgroups_map
  name                 = "InheritRgTags"
  scope                = data.azurerm_management_group.mgmtgroup[each.key].id
  policy_definition_id = data.azurerm_policy_definition.inherit-rgtags.id
  description          = "Policy Assignment created via an Acceptance Test"
  display_name         = "Inherit a tag from the resource group"

  parameters = jsonencode({
    tagName = {
      value = "Environment"
    }
  })

}*/