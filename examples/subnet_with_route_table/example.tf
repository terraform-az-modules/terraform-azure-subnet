provider "azurerm" {
  features {}
}

locals {
  name        = "app"
  environment = "test"
  label_order = ["name", "environment"]
}

##-----------------------------------------------------------------------------
## Resource Group module call
## Resource group in which all resources will be deployed.
##-----------------------------------------------------------------------------
module "resource_group" {
  source      = "terraform-az-modules/resource-group/azure"
  version     = "1.0.0"
  name        = local.name
  environment = local.environment
  label_order = local.label_order
  location    = "North Europe"
}

##-----------------------------------------------------------------------------
## Virtual Network module call.
##-----------------------------------------------------------------------------
module "vnet" {
  source              = "clouddrove/vnet/azure"
  version             = "1.0.4"
  name                = local.name
  environment         = local.environment
  label_order         = local.label_order
  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.resource_group_location
  address_spaces      = ["10.0.0.0/16"]
}

##-----------------------------------------------------------------------------
## Subnet module configuration 
##-----------------------------------------------------------------------------
module "subnets" {
  source               = "../../"
  name                 = local.name
  environment          = local.environment
  label_order          = local.label_order
  resource_group_name  = module.resource_group.resource_group_name
  location             = module.resource_group.resource_group_location
  virtual_network_name = module.vnet.vnet_name

  subnets = [
    {
      name                    = "subnet1"
      subnet_prefixes         = ["10.0.1.0/24"]
      route_table_name        = "rt1" # Route table association
      default_outbound_access = true
    },
    {
      name                    = "subnet2"
      subnet_prefixes         = ["10.0.2.0/24"]
      route_table_name        = "rt2"
      default_outbound_access = true
    }
  ]

  route_tables = [
    {
      name                          = "rt1"
      bgp_route_propagation_enabled = false
      routes = [
        {
          name           = "route1"
          address_prefix = "10.1.0.0/16"
          next_hop_type  = "VnetLocal"
        }
      ]
    },
    {
      name                          = "rt2"
      bgp_route_propagation_enabled = false
      routes = [
        {
          name           = "route2"
          address_prefix = "0.0.0.0/0"
          next_hop_type  = "Internet"
        }
      ]
    }
  ]
}
