output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "primary_aks_cluster" {
  value = module.aks_primary.cluster_name
}

output "secondary_aks_cluster" {
  value = module.aks_secondary.cluster_name
}