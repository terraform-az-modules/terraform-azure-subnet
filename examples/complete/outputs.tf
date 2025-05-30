##-----------------------------------------------------------------------------
## Subnet
##-----------------------------------------------------------------------------
output "subnet_ids" {
  value       = module.subnets.subnet_ids
  description = "Map of subnet names to their IDs."
}

output "subnet_names" {
  value       = module.subnets.subnet_names
  description = "Map of subnet names to their names."
}

##-----------------------------------------------------------------------------
## Tags
##-----------------------------------------------------------------------------
output "tags" {
  value       = module.subnets.tags
  description = "Tags applied to the resources."
}