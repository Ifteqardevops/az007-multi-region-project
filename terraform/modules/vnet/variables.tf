variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}

variable "location" {
  type        = string
  description = "Azure region for the VNet"
}

variable "vnet_cidr" {
  type        = string
  description = "Address space for the VNet"
}

variable "subnet_cidr" {
  type        = string
  description = "Address prefix for the AKS subnet"
}