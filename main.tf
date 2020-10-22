
terraform {
  required_version = ">0.13"
}

data "azurerm_client_config" "current" {
}
data "azurerm_subscription" "subscription" {
}

provider "azurerm" {
  version  = "~>2.20.0"
  features {}
}

provider "azurerm" {
  version  = "~>2.20.0"
  alias = "shared"
  subscription_id = var.subscription_id
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
  special = false
  #override_special = "|_%@"
}
