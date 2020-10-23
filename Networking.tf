resource "azurerm_resource_group" "vnet" {
  name                                  = "lvs-lab-network-rg"
  location                              = var.location

  tags                                  = var.tags
}


resource "azurerm_resource_group" "networkwatcher" {
  name     = "NetworkWatcherRG"
  location = "WestUS2"
}

resource "azurerm_network_watcher" "networkwatcher" {
  name                = "NetworkWatcher_westus2"
  location            = azurerm_resource_group.networkwatcher.location
  resource_group_name = azurerm_resource_group.networkwatcher.name
}


resource "azurerm_virtual_network" "vnet" {
  name                = "lvs-lab-vnet01"
  location            = azurerm_resource_group.vnet.location
  resource_group_name = azurerm_resource_group.vnet.name
  address_space       = ["10.200.100.0/22"]

  tags = var.tags
}

resource "azurerm_subnet" "gateway" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.vnet.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes       = ["10.200.100.0/25"]

  service_endpoints = [
  ]
}

resource "azurerm_subnet" "prod" {
  name                 = "lvs-lab-prod-snet"
  resource_group_name  = azurerm_resource_group.vnet.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.200.100.128/25"]
  enforce_private_link_endpoint_network_policies = true

  service_endpoints = [
    "Microsoft.Storage",
    "Microsoft.KeyVault"
  ]
}

resource "azurerm_subnet" "dev" {
  name                 = "lvs-lab-dev-snet"
  resource_group_name  = azurerm_resource_group.vnet.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes       = ["10.200.101.128/25"]
  enforce_private_link_endpoint_network_policies = true

  service_endpoints = [
    "Microsoft.Storage",
    "Microsoft.KeyVault"
  ]

}



#
# Network security groups
#

resource "azurerm_network_security_group" "prod" {
  name                = "${azurerm_subnet.prod.name}-nsg"
  location            = azurerm_resource_group.vnet.location
  resource_group_name = azurerm_resource_group.vnet.name

  tags = var.tags
}


resource "azurerm_network_watcher_flow_log" "prod" {
  network_watcher_name =  azurerm_network_watcher.networkwatcher.name
  resource_group_name  =  azurerm_resource_group.networkwatcher.name

  network_security_group_id = azurerm_network_security_group.prod.id
  storage_account_id        = azurerm_storage_account.storage.id
  enabled                   = true
  version                   = "2"

  retention_policy {
    enabled = true
    days    = 7
  }

  traffic_analytics {
    enabled               = true
    workspace_id          = azurerm_log_analytics_workspace.monitoring.workspace_id
    workspace_region      = azurerm_log_analytics_workspace.monitoring.location
    workspace_resource_id = azurerm_log_analytics_workspace.monitoring.id
    interval_in_minutes   = 10
  }
}

resource "azurerm_subnet_network_security_group_association" "prod" {
  subnet_id                 = azurerm_subnet.prod.id
  network_security_group_id = azurerm_network_security_group.prod.id
}



resource "azurerm_network_security_group" "dev" {
  name                = "${azurerm_subnet.dev.name}-nsg"
  location            = azurerm_resource_group.vnet.location
  resource_group_name = azurerm_resource_group.vnet.name

  tags = var.tags
}


resource "azurerm_network_watcher_flow_log" "dev" {
  network_watcher_name =  azurerm_network_watcher.networkwatcher.name
  resource_group_name  =  azurerm_resource_group.networkwatcher.name

  network_security_group_id = azurerm_network_security_group.dev.id
  storage_account_id        = azurerm_storage_account.storage.id
  enabled                   = true
  version                   = "2"

  retention_policy {
    enabled = true
    days    = 7
  }

  traffic_analytics {
    enabled               = true
    workspace_id          = azurerm_log_analytics_workspace.monitoring.workspace_id
    workspace_region      = azurerm_log_analytics_workspace.monitoring.location
    workspace_resource_id = azurerm_log_analytics_workspace.monitoring.id
    interval_in_minutes   = 10
  }
}


resource "azurerm_subnet_network_security_group_association" "dev" {
  subnet_id                 = azurerm_subnet.dev.id
  network_security_group_id = azurerm_network_security_group.dev.id
  }


resource "azurerm_network_security_group" "random" {
  name                = "demo_access-nsg"
  location            = "eastus2"
  resource_group_name = azurerm_resource_group.vnet.name

}
