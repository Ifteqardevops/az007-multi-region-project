terraform {
  required_version = ">= 1.5.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "tfstateyouruniqueaccname" # Update with your unique storage account
    container_name       = "tfstate"
    key                  = "multi-region-sre.tfstate"
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-sre-multiplatform"
  location = "eastus"
}

# Primary Region (East US)
module "vnet_primary" {
  source              = "../modules/vnet"
  resource_group_name = azurerm_resource_group.rg.name
  location            = "eastus"
  vnet_cidr           = "10.1.0.0/16"
  subnet_cidr         = "10.1.1.0/24"
}

module "aks_primary" {
  source              = "../modules/aks"
  cluster_name        = "aks-cluster-eastus"
  location            = "eastus"
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "akseastus"
  subnet_id           = module.vnet_primary.subnet_id
  node_count          = 2
}

# Secondary Region (West Europe)
module "vnet_secondary" {
  source              = "../modules/vnet"
  resource_group_name = azurerm_resource_group.rg.name
  location            = "westeurope"
  vnet_cidr           = "10.2.0.0/16"
  subnet_cidr         = "10.2.1.0/24"
}

module "aks_secondary" {
  source              = "../modules/aks"
  cluster_name        = "aks-cluster-westeurope"
  location            = "westeurope"
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "akswesteurope"
  subnet_id           = module.vnet_secondary.subnet_id
  node_count          = 2
}