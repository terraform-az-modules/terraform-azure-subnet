# ##-----------------------------------------------------------------------------
# ## Outputs
# ##-----------------------------------------------------------------------------
# output "label_order" {
#   value       = local.label_order
#   description = "Label order."
# }

##-----------------------------------------------------------------------------
## Subnet
##-----------------------------------------------------------------------------
output "subnet_ids" {
  value       = { for k, s in azurerm_subnet.subnet : k => s.id }
  description = "Map of subnet names to their IDs."
}

output "subnet_names" {
  value       = { for k, s in azurerm_subnet.subnet : k => s.name }
  description = "Map of subnet names to their names."
}

output "subnet_address_prefixes" {
  value       = { for k, s in azurerm_subnet.subnet : k => s.address_prefixes }
  description = "Map of subnet names to their address prefixes."
}

##-----------------------------------------------------------------------------
## Public IP
##-----------------------------------------------------------------------------
output "public_ip_addresses" {
  value       = { for k, pip in azurerm_public_ip.pip : k => pip.ip_address }
  description = "Map of NAT Gateway names to their associated public IP addresses."
}

output "public_ip_ids" {
  value       = { for k, pip in azurerm_public_ip.pip : k => pip.id }
  description = "Map of NAT Gateway names to their associated public IP resource IDs."
}

##-----------------------------------------------------------------------------
## Net Gateway
##-----------------------------------------------------------------------------
output "nat_gateway_ids" {
  value       = { for k, n in azurerm_nat_gateway.natgw : k => n.id }
  description = "Map of NAT Gateway names to their IDs."
}

output "nat_gateway_names" {
  value       = { for k, n in azurerm_nat_gateway.natgw : k => n.name }
  description = "Map of NAT Gateway names to their names."
}

output "subnet_nat_gateway_association_ids" {
  value       = { for k, a in azurerm_subnet_nat_gateway_association.subnet_assoc : k => a.id }
  description = "Map of subnet names to their NAT gateway association resource IDs."
}

##-----------------------------------------------------------------------------
## Route table
##-----------------------------------------------------------------------------
output "route_table_ids" {
  value       = { for k, r in azurerm_route_table.rt : k => r.id }
  description = "Map of route table names to their IDs."
}

output "route_table_names" {
  value       = { for k, r in azurerm_route_table.rt : k => r.name }
  description = "Map of route table names to their names."
}

output "subnet_route_table_association_ids" {
  value       = { for k, a in azurerm_subnet_route_table_association.main : k => a.id }
  description = "Map of subnet names to their route table association resource IDs."
}

##-----------------------------------------------------------------------------
## Tags
##-----------------------------------------------------------------------------
output "tags" {
  value       = module.labels.tags
  description = "Tags applied to the resources."
}
