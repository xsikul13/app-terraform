output "app_service_name" {
  value = "${azurerm_app_service.app_service.name}"
}

output "app_service_default_hostname" {
  value = "https://${azurerm_app_service.app_service.default_site_hostname}"
}