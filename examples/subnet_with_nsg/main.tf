provider "azurerm" {
  features {}
  subscription_id = ""
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
      name                          = "subnet1"
      subnet_prefixes               = ["10.0.1.0/24", "10.0.2.0/24"]
      attach_nat_gateway            = true     # Associate with NAT gateway
      nat_gateway_name              = "natgw1" # Specific NAT gateway reference
      route_table_name              = "rt1"    # Route table association
      service_endpoints             = ["Microsoft.Storage"]
      private_link_service_policies = true
      private_endpoint_policies     = "Enabled"
      default_outbound_access       = true
      nsg_association               = true
      network_security_group_id     = module.network_security_group.id

      delegations = [
        {
          name = "delegation1"
          service_delegations = [
            {
              name    = "Microsoft.ContainerInstance/containerGroups"
              actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
            }
          ]
        }
      ]
    },
    {
      name               = "subnet2"
      subnet_prefixes    = ["10.1.0.0/24"]
      attach_nat_gateway = false
      nsg_association    = false
    }
  ]
}

##-----------------------------------------------------------------------------
## Network Security Group module call.
##-----------------------------------------------------------------------------
module "network_security_group" {
  source                  = "clouddrove/network-security-group/azure"
  version                 = "1.1.0"
  name                    = local.name
  environment             = local.environment
  resource_group_name     = module.resource_group.resource_group_name
  resource_group_location = module.resource_group.resource_group_location
  inbound_rules = [
    {
      name                       = "ssh"
      priority                   = 101
      access                     = "Allow"
      protocol                   = "Tcp"
      source_address_prefix      = "VirtualNetwork"
      source_port_range          = "*"
      destination_address_prefix = "VirtualNetwork"
      destination_port_range     = "22"
      description                = "ssh allowed port"
    },
    {
      name                       = "https"
      priority                   = 102
      access                     = "Allow"
      protocol                   = "*"
      source_address_prefix      = "0.0.0.0/0"
      source_port_range          = "80,443"
      destination_address_prefix = "VirtualNetwork"
      destination_port_range     = "22"
      description                = "ssh allowed port"
    }
  ]
}
