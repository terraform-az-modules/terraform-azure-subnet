<!-- BEGIN_TF_DOCS -->

# Azure Subnets Module

This example demonstrates how to use the `terraform-azure-subnet` module to deploy complete Azure subnet.

---

## ✅ Requirements

| Name      | Version   |
|-----------|-----------|
| Terraform | >= 1.6.6  |
| Azurerm   | >= 3.116.0 |

---

## 🔌 Providers

No providers are explicitly defined in this example.

---

## 📦 Modules

| Name            | Source                      | Version |
|-----------------|-----------------------------|---------|
| resource_group   | clouddrove/resource-group/azure | 1.0.2   |
| subnets         | ../../                       | n/a     |
| vnet            | clouddrove/vnet/azure       | 1.0.4   |

---

## 🏗️ Resources

No additional resources are directly created in this example.

---

## 🔧 Inputs

_No input variables are defined in this example._

---

## 📤 Outputs

| Name                    | Description                                         |
|-------------------------|-----------------------------------------------------|
## 📤 Outputs

| Name                          | Description                                               |
|-------------------------------|-----------------------------------------------------------|
| `resource_group_location`     | The Azure location of the resource group.                 |
| `resource_group_name`         | The name of the resource group.                            |
| `subnet_ids`                 | Map of subnet names to their IDs.                          |
| `tags`                       | Tags applied to the resources.                             |
| `vnet_address_space`         | The address space of the virtual network.                  |
| `vnet_id`                    | The ID of the virtual network.                             |
| `vnet_name`                  | The name of the virtual network.                           |
<!-- END_TF_DOCS -->
