provider "azurerm" {
  # whilst the `version` attribute is optional, we recommend pinning to a given version of the Provider
  version = "~>1.34.0"
}

resource "azurerm_resource_group" "resource_group" {
    name = "${var.environment_tag}-${var.resource_group_name}"
    location = "${var.target_location}"

    tags = {
        environment = "${var.environment_tag}"
    }
}