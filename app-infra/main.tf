provider "azurerm" {
  version = "~>1.34.0"
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

  tags = {
      environment = "${var.environment_tag}"
  }
}


data "azurerm_container_registry" "cr" {
  name = "${var.docker_registry}"
  resource_group_name = "${var.cr_resource_group}"
}

resource "azurerm_app_service" "app_service" {
  name                = "nc19-appservice"
  location            = "${azurerm_resource_group.resource_group.location}"
  resource_group_name = "${azurerm_resource_group.resource_group.name}"
  app_service_plan_id = "${azurerm_app_service_plan.app_service_plan.id}"

  site_config {
    app_command_line = ""
    linux_fx_version = "DOCKER|${var.docker_registry}.azurecr.io/${var.docker_repository}:${var.docker_tag}"
  }

  app_settings = {
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "false"
    "DOCKER_REGISTRY_SERVER_URL"          = "https://${var.docker_registry}.azurecr.io"
    "DOCKER_REGISTRY_SERVER_USERNAME"     = "${data.azurerm_container_registry.cr.admin_username}"
    "DOCKER_REGISTRY_SERVER_PASSWORD"     = "${data.azurerm_container_registry.cr.admin_password}"
    "DB_CONNECTION_STRING" = ""
  }

  tags = {
    environment = "${var.environment_tag}"
  }
}
