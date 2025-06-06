<!-- BEGIN_TF_DOCS -->

# Azure Route Table Module

This example demonstrates how to use Terraform to deploy Azure Route Tables and associated resources.

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

| Name                                               | Type     |
|----------------------------------------------------|----------|
| azurerm_route_table.rt                             | resource |

---

## 🔧 Inputs

| Name                          | Description                                                                                                  | Type         | Default                                                       | Required |
|-------------------------------|--------------------------------------------------------------------------------------------------------------|--------------|---------------------------------------------------------------|:--------:|
| bgp_route_propagation_enabled  | Whether BGP route propagation should be enabled for a route table or similar resource.                       | bool         | `false`                                                       | no       |
| deployment_mode                | Specifies how the infrastructure/resource is deployed                                                        | string       | `"terraform"`                                                 | no       |
| environment                    | Environment (e.g. `prod`, `dev`, `staging`).                                                                | string       | `null`                                                        | no       |
| extra_tags                     | Variable to pass extra tags.                                                                                 | map(string)  | `null`                                                        | no       |
| label_order                    | Label order, e.g. `name`,`application`,`centralus`.                                                          | list(any)    | <pre>[<br>  "name",<br>  "environment",<br>  "location"<br>]</pre> | no       |
| location                       | The location/region where the virtual network is created.                                                    | string       | `""`                                                          | no       |
| managedby                      | ManagedBy, eg 'terraform-az--modules'.                                                                       | string       | `"terraform-az-modules"`                                      | no       |
| name                           | Name (e.g. `app` or `cluster`).                                                                              | string       | `null`                                                        | no       |
| repository                     | Terraform current module repo                                                                                | string       | `"https://github.com/terraform-az-modules/terraform-azure-subnet.git"` | no       |
| resource_group_name            | The name of an existing resource group to be imported.                                                       | string       | `null`                                                        | no       |
| resource_position_prefix       | Controls the placement of the resource type keyword (e.g., "vnet", "ddospp") in the resource name.           | bool         | `true`                                                        | no       |
| route_tables                   | List of route tables with their configuration and routes.                                                    | list(object) | `[]`                                                          | no       |
| routes                         | List of routes to associate with route tables.                                                               | list(object) | `[]`                                                          | no       |

---

## 📤 Outputs

| Name                | Description                                                       |
|---------------------|-------------------------------------------------------------------|
| route_table_ids     | The IDs of the Azure Route Tables created.                        |
| route_table_names   | The names of the Azure Route Table resources.                     |

<!-- END_TF_DOCS -->
