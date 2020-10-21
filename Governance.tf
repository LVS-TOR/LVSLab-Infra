
resource "azuread_group" "global-owner" {
  name = "LVS LAB - AZ Global - Owners"
}
resource "azuread_group" "global-contributor" {
  name = "LVS LAB - AZ Global - Contributors"
}

resource "azuread_group" "security-admin" {
  name = "LVS LAB - AZ Security - Admin"
}

##############################################################################################################


resource "azurerm_role_assignment" "global-contributor" {
  scope              = data.azurerm_subscription.subscription.id
  role_definition_name = "Contributor"
  principal_id       = azuread_group.global-contributor.id
}

resource "azurerm_role_assignment" "global-owner" {
  scope              = data.azurerm_subscription.subscription.id
  role_definition_name = "Owner"
  principal_id       = azuread_group.global-owner.id
}

resource "azurerm_role_assignment" "security-admin" {
  scope                = data.azurerm_subscription.subscription.id
  role_definition_name = "Security Admin"
  principal_id       = azuread_group.security-admin.id
}


##############################################################################################################



data "azurerm_policy_definition" "allowed-locations" {
  display_name = "Allowed locations"
}


resource "azurerm_policy_assignment" "allowed-locations" {
  name                 = "AllowedLocations"
  scope                = data.azurerm_subscription.subscription.id
  policy_definition_id = data.azurerm_policy_definition.allowed-locations.id
  description          = "Policy Assignment created via an Acceptance Test"
  display_name         = "Allowed locations"

  parameters = jsonencode({
    listOfAllowedLocations = {
      value = [var.location]
    }
  })
  depends_on = [azurerm_managed_disk.compute-vm-disk4,
                azurerm_managed_disk.compute-vm-disk3,
                azurerm_managed_disk.compute-vm-disk2,
                azurerm_virtual_machine.compute-vm1,
                azurerm_virtual_machine.compute-vm2,
  ]
}

######################################

data "azurerm_policy_definition" "match-location" {
  display_name = "Audit resource location matches resource group location"
}

resource "azurerm_policy_assignment" "match-location" {
  name                 = "AuditLocMatchRG"
  scope                = data.azurerm_subscription.subscription.id
  policy_definition_id = data.azurerm_policy_definition.match-location.id
  description          = "Policy Assignment created via an Acceptance Test"
  display_name         = "Audit resource location matches resource group location"

  depends_on = [azurerm_managed_disk.compute-vm-disk4,
                azurerm_managed_disk.compute-vm-disk3,
                azurerm_managed_disk.compute-vm-disk2,
                azurerm_virtual_machine.compute-vm1,
                azurerm_virtual_machine.compute-vm2,
  ]
}

#################################################################################### Custom subscription owner roles should not exist

data "azurerm_policy_definition" "no-custom-owner" {
  display_name = "Custom subscription owner roles should not exist"
}

resource "azurerm_policy_assignment" "no-custom-owner" {
  name                 = "AuditCustomOwner"
  scope                = data.azurerm_subscription.subscription.id
  policy_definition_id = data.azurerm_policy_definition.no-custom-owner.id
  description          = "Policy Assignment created via an Acceptance Test"
  display_name         = "Custom subscription owner roles should not exist"

  depends_on = [azurerm_managed_disk.compute-vm-disk4,
                azurerm_managed_disk.compute-vm-disk3,
                azurerm_managed_disk.compute-vm-disk2,
                azurerm_virtual_machine.compute-vm1,
                azurerm_virtual_machine.compute-vm2,
  ]

}

####################################################################################### Unattached disks should be encrypted

data "azurerm_policy_definition" "unattached-encrypt" {
  display_name = "Unattached disks should be encrypted"
}

resource "azurerm_policy_assignment" "unattached-encrypt" {
  name                 = "AuditUnAttchDisksEncrypt"
  scope                = data.azurerm_subscription.subscription.id
  policy_definition_id = data.azurerm_policy_definition.unattached-encrypt.id
  description          = "Policy Assignment created via an Acceptance Test"
  display_name         = "Unattached disks should be encrypted"

  depends_on = [azurerm_managed_disk.compute-vm-disk4,
                azurerm_managed_disk.compute-vm-disk3,
                azurerm_managed_disk.compute-vm-disk2,
                azurerm_virtual_machine.compute-vm1,
                azurerm_virtual_machine.compute-vm2,
  ]
  
}


########################################################################### Key Vault should use a virtual network service endpoint

data "azurerm_policy_definition" "kvaultservendpoint" {
  display_name = "Key Vault should use a virtual network service endpoint"
}

resource "azurerm_policy_assignment" "kvaultservendpoint" {
  name                 = "KeyVaultServiceEndpoint"
  scope                = data.azurerm_subscription.subscription.id
  policy_definition_id = data.azurerm_policy_definition.kvaultservendpoint.id
  description          = "Policy Assignment created via an Acceptance Test"
  display_name         = "Key Vault should use a virtual network service endpoint"

  depends_on = [azurerm_managed_disk.compute-vm-disk4,
                azurerm_managed_disk.compute-vm-disk3,
                azurerm_managed_disk.compute-vm-disk2,
                azurerm_virtual_machine.compute-vm1,
                azurerm_virtual_machine.compute-vm2,
  ]

}


########################################################################### Network interfaces should not have public IPs

data "azurerm_policy_definition" "nopublicip" {
  display_name = "Network interfaces should not have public IPs"
}

resource "azurerm_policy_assignment" "nopublicip" {
  name                 = "NoPublicIP"
  scope                = data.azurerm_subscription.subscription.id
  policy_definition_id = data.azurerm_policy_definition.nopublicip.id
  description          = "Policy Assignment created via an Acceptance Test"
  display_name         = "Network interfaces should not have public IPs"

  depends_on = [azurerm_managed_disk.compute-vm-disk4,
                azurerm_managed_disk.compute-vm-disk3,
                azurerm_managed_disk.compute-vm-disk2,
                azurerm_virtual_machine.compute-vm1,
                azurerm_virtual_machine.compute-vm2,
  ]

}

########################################################################### Storage Accounts should use a virtual network service endpoint

data "azurerm_policy_definition" "saservendpoint" {
  display_name = "Storage Accounts should use a virtual network service endpoint"
}

resource "azurerm_policy_assignment" "saservendpoint" {
  name                 = "SAServiceEndpoint"
  scope                = data.azurerm_subscription.subscription.id
  policy_definition_id = data.azurerm_policy_definition.saservendpoint.id
  description          = "Policy Assignment created via an Acceptance Test"
  display_name         = "Storage Accounts should use a virtual network service endpoint"

  depends_on = [azurerm_managed_disk.compute-vm-disk4,
                azurerm_managed_disk.compute-vm-disk3,
                azurerm_managed_disk.compute-vm-disk2,
                azurerm_virtual_machine.compute-vm1,
                azurerm_virtual_machine.compute-vm2,
  ]

}

########################################################################### Network interfaces should disable IP forwarding

data "azurerm_policy_definition" "auditipforwarding" {
  display_name = "Network interfaces should disable IP forwarding"
}

resource "azurerm_policy_assignment" "auditipforwarding" {
  name                 = "AuditIPForwarding"
  scope                = data.azurerm_subscription.subscription.id
  policy_definition_id = data.azurerm_policy_definition.auditipforwarding.id
  description          = "Policy Assignment created via an Acceptance Test"
  display_name         = "Network interfaces should disable IP forwarding"
 
  depends_on = [azurerm_managed_disk.compute-vm-disk4,
                azurerm_managed_disk.compute-vm-disk3,
                azurerm_managed_disk.compute-vm-disk2,
                azurerm_virtual_machine.compute-vm1,
                azurerm_virtual_machine.compute-vm2,
  ]

}

########################################################################### Require a tag on resource groups

data "azurerm_policy_definition" "requiretags" {
  display_name = "Require a tag on resource groups"
}


resource "azurerm_policy_assignment" "requiretags" {
  name                 = "RequireTags"
  scope                = data.azurerm_subscription.subscription.id
  policy_definition_id = data.azurerm_policy_definition.requiretags.id
  description          = "Policy Assignment created via an Acceptance Test"
  display_name         = "Require a tag on resource groups"

  parameters = jsonencode({
    tagName = {
      value = "Environment"
    }
  })

  depends_on = [azurerm_managed_disk.compute-vm-disk4,
                azurerm_managed_disk.compute-vm-disk3,
                azurerm_managed_disk.compute-vm-disk2,
                azurerm_virtual_machine.compute-vm1,
                azurerm_virtual_machine.compute-vm2,
  ]
}



data "azurerm_policy_definition" "requireflowlog" {
  display_name = "Flow log should be configured for every network security group"
}


resource "azurerm_policy_assignment" "requireflowlog" {
  name                 = "RequireFlowlLog"
  scope                = data.azurerm_subscription.subscription.id
  policy_definition_id = data.azurerm_policy_definition.requiretags.id
  description          = "Flow log should be configured for every network security group"
  display_name         = "Require a tag on resource groups"

  depends_on = [azurerm_managed_disk.compute-vm-disk4,
                azurerm_managed_disk.compute-vm-disk3,
                azurerm_managed_disk.compute-vm-disk2,
                azurerm_virtual_machine.compute-vm1,
                azurerm_virtual_machine.compute-vm2,
  ]
}
There should be more than one owner assigned to your subscription