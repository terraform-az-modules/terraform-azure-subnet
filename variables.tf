##-----------------------------------------------------------------------------
## Naming convention
##-----------------------------------------------------------------------------
variable "resource_position_prefix" {
  type        = bool
  default     = true
  description = <<EOT
Controls the placement of the resource type keyword (e.g., "vnet", "ddospp") in the resource name.

- If true, the keyword is prepended: "vnet-core-dev".
- If false, the keyword is appended: "core-dev-vnet".

This helps maintain naming consistency based on organizational preferences.
EOT
}
##-----------------------------------------------------------------------------
## Labels
##-----------------------------------------------------------------------------
variable "name" {
  type        = string
  default     = null
  description = "Name  (e.g. `app` or `cluster`)."
}

variable "repository" {
  type        = string
  default     = "https://github.com/clouddrove/terraform-azure-subnet.git"
  description = "Terraform current module repo"

  validation {
    condition     = can(regex("^https://", var.repository))
    error_message = "The module-repo value must be a valid Git repo link."
  }
}

variable "virtual_network_name" {
  type        = string
  default     = null
  description = "Name of the virtual network"
}

variable "environment" {
  type        = string
  default     = null
  description = "Environment (e.g. `prod`, `dev`, `staging`)."
}

variable "label_order" {
  type        = list(any)
  default     = ["name", "environment", "location"]
  description = "The order of labels used to construct resource names or tags. If not specified, defaults to ['name', 'environment', 'location']."
}

variable "managedby" {
  type        = string
  default     = "terraform-az-modules"
  description = "ManagedBy, eg 'terraform-az--modules'."
}

variable "deployment_mode" {
  type        = string
  default     = "terraform"
  description = "Specifies how the infrastructure/resource is deployed"
}

variable "extra_tags" {
  type        = map(string)
  default     = null
  description = "Variable to pass extra tags."
}

variable "enable" {
  type        = bool
  default     = true
  description = "Flag to control the module creation"
}

variable "resource_group_name" {
  type        = string
  default     = null
  description = "The name of an existing resource group to be imported."
}

variable "location" {
  type        = string
  default     = ""
  description = "The location/region where the virtual network is created."
}

##-----------------------------------------------------------------------------
## Subnet
##-----------------------------------------------------------------------------
variable "subnets" {
  description = "List of subnets to create"
  type = list(object({
    name                          = string
    subnet_prefixes               = list(string)
    attach_nat_gateway            = optional(bool, false)
    nat_gateway_name              = optional(string)
    route_table_name              = optional(string)
    nsg_association               = optional(bool, false)
    service_endpoints             = optional(list(string), [])
    service_endpoint_policy_ids   = optional(list(string), [])
    private_link_service_policies = optional(bool, true)
    private_endpoint_policies     = optional(string, "Enabled")
    default_outbound_access       = optional(bool, true)
    network_security_group_id     = optional(string, null)
    delegations = optional(list(object({
      name = string
      service_delegations = list(object({
        name    = string
        actions = list(string)
      }))
    })), [])
  }))
  default = []
}

##-----------------------------------------------------------------------------
## Nat Gateway
##-----------------------------------------------------------------------------
variable "nat_gateways" {
  description = "List of NAT Gateways to create"
  type = list(object({
    name                     = string
    sku_name                 = optional(string, "Standard")
    nat_gateway_idle_timeout = optional(number, 4)
    zones                    = optional(list(string), [])
  }))
  default = []
}

variable "enable_nat_gateway" {
  type        = bool
  default     = false
  description = "Flag to control route table creation."
}

##-----------------------------------------------------------------------------
## Route Table
##-----------------------------------------------------------------------------
variable "route_tables" {
  description = "List of route tables with their configuration and routes."
  type = list(object({
    name                          = string
    bgp_route_propagation_enabled = optional(bool, false)
    routes = optional(list(object({
      name                   = string
      address_prefix         = string
      next_hop_type          = string
      next_hop_in_ip_address = optional(string)
    })), [])
  }))
  default = []
}

variable "enable_route_table" {
  type        = bool
  default     = false
  description = "Flag to control route table creation."
}

variable "nsg_association" {
  type        = bool
  default     = false
  description = "Flag to control the nsg association"
}

variable "allocation_method" {
  type        = string
  default     = "Static"
  description = "Defines the allocation method for this IP address. Possible values are Static or Dynamic."
}

variable "sku" {
  type        = string
  default     = "Standard"
  description = "The SKU of the Public IP. Accepted values are Basic and Standard. Defaults to Basic. Changing this forces a new resource to be created."
}

variable "network_security_group_id" {
  type        = string
  default     = null
  description = "Resource id for network security group"
}



