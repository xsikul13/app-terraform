provider "azurerm" {
  # whilst the `version` attribute is optional, we recommend pinning to a given version of the Provider
  version = "~>1.34.0"
}

terraform {
  backend "azurerm" {
    storage_account_name  = "nc19tfstate"
    container_name        = "tfstate"
    key                   = "terraform.tfstate"
  }
}

resource "azurerm_resource_group" "resource_group" {
    name = "${var.environment_tag}-${var.resource_group_name}"
    location = "${var.target_location}"

    tags = {
        environment = "${var.environment_tag}"
    }
}

resource "azurerm_app_service_plan" "app_service_plan" {
  name                = "app_service_plan"
  location            = "${azurerm_resource_group.resource_group.location}"
  resource_group_name = "${azurerm_resource_group.resource_group.name}"
  kind = "Linux"
  reserved = true

  sku {
    tier = "Standard"
    size = "B1"
  }
}
