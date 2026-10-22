terraform {
  required_version = ">= 1.5.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
  backend "azurerm" {
    # Configure remote state storage parameters via backend config or CLI flags
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-sre-multiplatform"
  location = "eastus"
}

# Primary Region Network (East US)
module "vnet_primary" {
  source              = "../modules/vnet"
  resource_group_name = azurerm_resource_group.rg.name
  location            = "eastus"
  vnet_cidr           = "10.1.0.0/16"
  subnet_cidr         = "10.1.1.0/24"
}

# Secondary Region Network (West Europe)
module "vnet_secondary" {
  source              = "../modules/vnet"
  resource_group_name = azurerm_resource_group.rg.name
  location            = "westeurope"
  vnet_cidr           = "10.2.0.0/16"
  subnet_cidr         = "10.2.1.0/24"
}