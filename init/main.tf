provider "azurerm" {
  # whilst the `version` attribute is optional, we recommend pinning to a given version of the Provider
  version = "~>1.34.0"
}

resource "azurerm_resource_group" "resource_group" {
    name = "${var.resource_group_name}"
    location = "${var.target_location}"
}

# Storage account creation
resource "azurerm_storage_account" "storage_account" {
    name = "nc19sa"
    resource_group_name = "${azurerm_resource_group.resource_group.name}"
    location = "${azurerm_resource_group.resource_group.location}"
    account_replication_type = "LRS"
    account_tier = "Standard"

}

resource "azurerm_storage_container" "terraform_storage_container" {
    name="terraform-storage"
    storage_account_name = "${azurerm_storage_account.storage_account.name}"
    resource_group_name = "${azurerm_resource_group.resource_group.name}"
}

#Container Registry for Docker
resource "azurerm_container_registry" "nc19cr" {
    name="nc19cr"
    admin_enabled="true"
    location="${azurerm_resource_group.resource_group.location}"
    resource_group_name="${azurerm_resource_group.resource_group.name}"
    sku="Basic"
}

output "ContainerRegistryPassword" {
    value="${azurerm_container_registry.nc19cr.admin_password}"
}


#Service Principal role creation
data "azurerm_subscription" "current" {}

data "azurerm_role_definition" "contributor" {
  name = "Contributor"
}

provider "azuread" {
  version = "0.6.0"
}

# Create an application
resource "azuread_application" "nc19app" {
  name = "nc19app"
}

resource "azuread_application_password" "nc19app" {
  application_id = "${azuread_application.nc19app.id}"
  value                = "VT=uSgbTanZhyz@%nL9Hpd+Tfay_MRV#"
  end_date             = "2020-01-01T01:02:03Z"
}

resource "azurerm_role_assignment" "nc19appra" {
  principal_id="${azuread_application.nc19app.id}"
  role_definition_id="${data.azurerm_role_definition.contributor.id}"
  scope="${data.azurerm_subscription.current.id}"
}