##-----------------------------------------------------------------------------
## Tagging Module – Applies standard tags to all resources
##-----------------------------------------------------------------------------
module "labels" {
  source          = "terraform-az-modules/tags/azure"
  version         = "1.0.0"
  name            = var.name
  location        = var.location
  environment     = var.environment
  managedby       = var.managedby
  label_order     = var.label_order
  repository      = var.repository
  deployment_mode = var.deployment_mode
  extra_tags      = var.extra_tags
}

##-----------------------------------------------------------------------------
## Public IP for NAT Gateway – Creates a public IP for NAT Gateways with attachment flag
##-----------------------------------------------------------------------------
resource "azurerm_public_ip" "pip" {
  for_each = {
    for natgw in var.nat_gateways : natgw.name => natgw
    if var.enable && var.enable_nat_gateway
  }

  name                = var.resource_position_prefix ? format("ng-ip-%s-%s", local.name, each.value.name) : format("%s-ng-ip-%s", local.name, each.value.name)
  allocation_method   = var.allocation_method
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku
  tags                = module.labels.tags
}

##-----------------------------------------------------------------------------
## NAT Gateway – Creates a nat-gateway if required 
##-----------------------------------------------------------------------------
resource "azurerm_nat_gateway" "natgw" {
  for_each = var.enable && var.enable_nat_gateway ? { for natgw in var.nat_gateways : natgw.name => natgw } : {}

  name                    = each.value.name
  location                = var.location
  resource_group_name     = var.resource_group_name
  sku_name                = lookup(each.value, "sku_name", "Standard")
  idle_timeout_in_minutes = lookup(each.value, "nat_gateway_idle_timeout", 4)
  zones                   = lookup(each.value, "zones", [])
  tags                    = module.labels.tags
}

##-----------------------------------------------------------------------------
## Subnet – Creates a subnet with optional service endpoints, delegations, etc
##-----------------------------------------------------------------------------
resource "azurerm_subnet" "subnet" {
  for_each = var.enable ? { for subnet in var.subnets : subnet.name => subnet } : {}

  name                                          = each.value.name
  resource_group_name                           = var.resource_group_name
  virtual_network_name                          = var.virtual_network_name
  address_prefixes                              = each.value.subnet_prefixes
  service_endpoints                             = lookup(each.value, "service_endpoints", [])
  service_endpoint_policy_ids                   = lookup(each.value, "service_endpoint_policy_ids", [])
  private_link_service_network_policies_enabled = lookup(each.value, "private_link_service_policies", true)
  private_endpoint_network_policies             = lookup(each.value, "private_endpoint_policies", "Enabled")
  default_outbound_access_enabled               = lookup(each.value, "default_outbound_access", true)

  dynamic "delegation" {
    for_each = lookup(each.value, "delegations", [])
    content {
      name = delegation.value.name
      dynamic "service_delegation" {
        for_each = delegation.value.service_delegations
        content {
          name    = service_delegation.value.name
          actions = service_delegation.value.actions
        }
      }
    }
  }
}

##-----------------------------------------------------------------------------
## Route Table – Creates route table with custom routes if required
##-----------------------------------------------------------------------------
resource "azurerm_route_table" "rt" {
  for_each = var.enable && var.enable_route_table ? {
    for rt in var.route_tables : rt.name => rt
  } : {}

  name                          = each.value.name
  location                      = var.location
  resource_group_name           = var.resource_group_name
  bgp_route_propagation_enabled = lookup(each.value, "bgp_route_propagation_enabled", false)
  tags                          = module.labels.tags

  dynamic "route" {
    for_each = lookup(each.value, "routes", [])
    content {
      name                   = route.value.name
      address_prefix         = route.value.address_prefix
      next_hop_type          = route.value.next_hop_type
      next_hop_in_ip_address = lookup(route.value, "next_hop_in_ip_address", null)
    }
  }
}

##-----------------------------------------------------------------------------
## Route Table, NAT Gateway, NSG and Public IP Subnet Association
##-----------------------------------------------------------------------------
resource "azurerm_subnet_route_table_association" "main" {
  for_each = {
    for subnet in var.subnets : subnet.name => subnet
    if var.enable && var.enable_route_table && lookup(subnet, "route_table_name", null) != null
  }

  subnet_id      = azurerm_subnet.subnet[each.key].id
  route_table_id = azurerm_route_table.rt[each.value.route_table_name].id
}

resource "azurerm_subnet_nat_gateway_association" "subnet_assoc" {
  for_each = {
    for subnet in var.subnets : subnet.name => subnet
    if var.enable && var.enable_nat_gateway && lookup(subnet, "nat_gateway_name", null) != null
  }

  subnet_id      = azurerm_subnet.subnet[each.key].id
  nat_gateway_id = azurerm_nat_gateway.natgw[each.value.nat_gateway_name].id
}

resource "azurerm_nat_gateway_public_ip_association" "pip_assoc" {
  for_each = {
    for natgw in var.nat_gateways : natgw.name => natgw
    if var.enable && var.enable_nat_gateway
  }

  nat_gateway_id       = azurerm_nat_gateway.natgw[each.key].id
  public_ip_address_id = azurerm_public_ip.pip[each.key].id
}

resource "azurerm_subnet_network_security_group_association" "nsg_subnet_association" {
  for_each = var.enable ? {
    for subnet in var.subnets : subnet.name => subnet
    if subnet.nsg_association
  } : {}

  subnet_id                 = azurerm_subnet.subnet[each.key].id
  network_security_group_id = each.value.network_security_group_id
}
