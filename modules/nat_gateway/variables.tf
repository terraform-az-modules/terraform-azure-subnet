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
  default     = "https://github.com/terraform-az-modules/terraform-azure-subnet.git"
  description = "Terraform current module repo"

  validation {
    condition     = can(regex("^https://", var.repository))
    error_message = "The module-repo value must be a valid Git repo link."
  }
}

variable "environment" {
  type        = string
  default     = null
  description = "Environment (e.g. `prod`, `dev`, `staging`)."
}

variable "label_order" {
  type        = list(any)
  default     = ["name", "environment", "location"]
  description = "Label order, e.g. `name`,`application`,`centralus`."
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

variable "allocation_method" {
  type        = string
  default     = "Static"
  description = "Defines the allocation method for this IP address."
}

variable "sku" {
  type        = string
  default     = "Standard"
  description = "The SKU of the Public IP."
}

variable "nat_gateway_idle_timeout" {
  description = "The idle timeout which should be used in minutes for the NAT Gateway. Defaults to 4."
  type        = number
  default     = 4
}

variable "zones" {
  description = "A list of availability zones in which the NAT Gateway should be deployed."
  type        = list(string)
  default     = []
}