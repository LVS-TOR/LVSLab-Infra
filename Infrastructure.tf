resource "azurerm_resource_group" "infra" {
  name                                  = "lvs-lab-infra-rg"
  location                              = var.location

  tags                                  = var.tags
}


resource "azurerm_log_analytics_workspace" "monitoring" {
  name                = "lvs-lab-la01"
  resource_group_name = azurerm_resource_group.infra.name
  location            = azurerm_resource_group.infra.location
  sku                 = "pergb2018"
  retention_in_days   = 31

  tags = var.tags
}


resource "azurerm_automation_account" "monitoring" {
  name                = "lvs-lab-aa01"
  resource_group_name = azurerm_resource_group.infra.name
  location            = azurerm_resource_group.infra.location
  
  sku_name            = "Basic"
  
  tags                = var.tags
}

resource "azurerm_log_analytics_linked_service" "monitoring" {
  resource_group_name = azurerm_resource_group.infra.name
  workspace_name      = azurerm_log_analytics_workspace.monitoring.name
  resource_id         = azurerm_automation_account.monitoring.id
}


resource "azurerm_storage_account" "storage" {
  name                      = lower("lvslab${random_string.random.result}")
  resource_group_name       = azurerm_resource_group.infra.name
  location                  = azurerm_resource_group.infra.location
  account_kind              = "StorageV2"
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  access_tier               = "Hot"
  enable_https_traffic_only = true
  blob_properties {
    delete_retention_policy {
      days = 10
    }
  }

  network_rules {
      bypass                     = ["AzureServices"]
      default_action             = "Deny"
      ip_rules                   = null
      virtual_network_subnet_ids = [azurerm_subnet.prod.id]
    }

  tags = var.tags
}

resource "azurerm_private_endpoint" "storage" {
  name                                = lower("${azurerm_storage_account.storage.name}-pe")
  resource_group_name                 = azurerm_resource_group.infra.name
  location                            = azurerm_resource_group.infra.location
  subnet_id                           = azurerm_subnet.prod.id

  private_service_connection {
    name                              =lower("${azurerm_storage_account.storage.name}-pe")
    private_connection_resource_id    = azurerm_storage_account.storage.id
    is_manual_connection              = false
    subresource_names                 = ["blob"]
  }
}

resource "azurerm_key_vault" "security" {
  name                = lower("lvs-lab-kv01")
  location            = azurerm_resource_group.infra.location
  resource_group_name = azurerm_resource_group.infra.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"
  soft_delete_enabled         = true
  #soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  enabled_for_deployment          = true
  enabled_for_disk_encryption     = true
  enabled_for_template_deployment = true

  network_acls {
      bypass                     = "AzureServices"
      default_action             = "Deny"
      ip_rules                   = null
      virtual_network_subnet_ids = [azurerm_subnet.prod.id]
    }


  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    certificate_permissions                 = ["Get","List","Update","Create","Import","Delete","Recover","Backup","Restore","ManageContacts","ManageIssuers","GetIssuers","ListIssuers","SetIssuers","DeleteIssuers"]
    key_permissions                         = ["Get","List","Update","Create","Import","Delete","Recover","Backup","Restore"]
    secret_permissions                      = ["Get","List","Set","Recover","Delete","Backup","Restore"]
    storage_permissions                     = ["get"]
  }

  tags = var.tags
}
