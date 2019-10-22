provider "azurerm" {
  # whilst the `version` attribute is optional, we recommend pinning to a given version of the Provider
  version = "~>1.34.0"
}

#terraform {
#  backend "azurerm" {
#    storage_account_name  = "nc19tfstate"
#    container_name        = "tfstate"
#    key                   = "terraform.tfstate"
#  }
#}

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


resource "azurerm_app_service" "app_service" {
  name                = "nc19-appservice"
  location            = "${azurerm_resource_group.resource_group.location}"
  resource_group_name = "${azurerm_resource_group.resource_group.name}"
  app_service_plan_id = "${azurerm_app_service_plan.app_service_plan.id}"

  site_config {
    app_command_line = ""
    linux_fx_version = "DOCKER|cu19registry.azurecr.io/app-dotnet:4"
  }

  app_settings = {
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "false"
    "DOCKER_REGISTRY_SERVER_URL"          = "https://cu19registry.azurecr.io"
    "DOCKER_REGISTRY_SERVER_USERNAME"     = "cu19registry"
    "DOCKER_REGISTRY_SERVER_PASSWORD"     = "hWjQZKeQIFSUt9b5vUV/5554MjgX00vW"
  }
}
