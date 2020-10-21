
terraform {
  required_version = "~>0.13"
}

data "azurerm_client_config" "current" {
}
data "azurerm_subscription" "subscription" {
}

provider "azurerm" {
  version  = "~>2.10.0"
  features {}
}

provider "azurerm" {
  version  = "~>2.10.0"
  alias = "shared"
  subscription_id = "8ba15d1f-4cf7-4792-b953-707d3b7fe12d"
  features {}
  skip_provider_registration = "false"
}

resource "random_string" "random" {
  length  = 4
  special = false
  upper   = false
}


resource "random_password" "password" {
  length = 16
  special = true
  override_special = "_%@"
}


