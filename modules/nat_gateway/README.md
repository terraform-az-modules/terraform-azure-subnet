<!-- BEGIN_TF_DOCS -->

# Azure Subnet with NAT Gateway Module

This example demonstrates how to use Terraform to deploy an Azure NAT Gateway with associated Public IP and subnet integration.

---

## ✅ Requirements

| Name      | Version   |
|-----------|-----------|
| Terraform | >= 1.6.6  |
| azurerm   | >= 3.116.0|

---

## 🔌 Providers

| Name     | Version   |
|----------|-----------|
| azurerm  | >= 3.116.0|

---

## 📦 Modules

| Name   | Source                                   | Version |
|--------|------------------------------------------|---------|
| labels | terraform-az-modules/tags/azure          | 1.0.0   |

---

## 🏗️ Resources

| Name                                                                 | Type      |
|----------------------------------------------------------------------|-----------|
| azurerm_nat_gateway.natgw                                            | resource  |
| azurerm_nat_gateway_public_ip_association.pip_assoc                  | resource  |
| azurerm_public_ip.pip                                                | resource  |

---

## 🔧 Inputs

| Name                        | Description                                                                                                  | Type         | Default                                                       | Required |
|-----------------------------|--------------------------------------------------------------------------------------------------------------|--------------|---------------------------------------------------------------|:--------:|
| allocation_method           | Defines the allocation method for this IP address.                                                           | string       | `"Static"`                                                    | no       |
| deployment_mode             | Specifies how the infrastructure/resource is deployed                                                        | string       | `"terraform"`                                                 | no       |
| enable_nat_gateway          | Flag to control route table creation.                                                                        | bool         | `false`                                                       | no       |
| environment                 | Environment (e.g. `prod`, `dev`, `staging`).                                                                | string       | `null`                                                        | no       |
| extra_tags                  | Variable to pass extra tags.                                                                                 | map(string)  | `null`                                                        | no       |
| label_order                 | Label order, e.g. `name`,`application`,`centralus`.                                                          | list(any)    | <pre>[<br>  "name",<br>  "environment",<br>  "location"<br>]</pre> | no       |
| location                    | The location/region where the virtual network is created.                                                    | string       | `""`                                                          | no       |
| managedby                   | ManagedBy, eg 'terraform-az--modules'.                                                                       | string       | `"terraform-az-modules"`                                      | no       |
| name                        | Name (e.g. `app` or `cluster`).                                                                              | string       | `null`                                                        | no       |
| nat_gateway_idle_timeout    | The idle timeout which should be used in minutes for the NAT Gateway. Defaults to 4.                         | number       | `4`                                                           | no       |
| nat_gateways                | List of NAT Gateways to create                                                                               | list(object) | `[]`                                                          | no       |
| repository                  | Terraform current module repo                                                                                | string       | `"https://github.com/terraform-az-modules/terraform-azure-subnet.git"` | no       |
| resource_group_name         | The name of an existing resource group to be imported.                                                       | string       | `null`                                                        | no       |
| resource_position_prefix    | Controls the placement of the resource type keyword (e.g., "vnet", "ddospp") in the resource name.           | bool         | `true`                                                        | no       |
| sku                         | The SKU of the Public IP.                                                                                    | string       | `"Standard"`                                                  | no       |
| zones                       | A list of availability zones in which the NAT Gateway should be deployed.                                    | list(string) | `[]`                                                          | no       |

---

## 📤 Outputs

| Name                | Description                                                                 |
|---------------------|-----------------------------------------------------------------------------|
| nat_gateway_ids     | The ID of the Azure NAT Gateway created.                                    |
| nat_gateway_names   | The name of the Azure NAT Gateway resource.                                 |
| public_ip_addresses | The actual allocated public IPv4 address for the Azure Public IP resource.  |
| public_ip_ids       | The unique Azure Resource Manager identifier for the Public IP resource.    |

<!-- END_TF_DOCS -->
