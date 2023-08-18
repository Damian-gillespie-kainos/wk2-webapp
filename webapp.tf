# Azure service plan is Azure's web hosting service. We need to set this up in order to host our web app
resource "azurerm_service_plan" "kpa23-appserviceplan-dg" {
  name                = "kpa23-appserviceplan-dg"
  location            = azurerm_resource_group.kpa23-rg-dg.location
  resource_group_name = azurerm_resource_group.kpa23-rg-dg.name
  os_type             = "Linux"
  sku_name            = "B1"
}

# We launched a linux web app
resource "azurerm_linux_web_app" "kpa23-webapp-dg" {
  name                      = "kpa23-appserviceplan-dg"
  location                  = azurerm_resource_group.kpa23-rg-dg.location
  resource_group_name       = azurerm_resource_group.kpa23-rg-dg.name
  service_plan_id           = azurerm_service_plan.kpa23-appserviceplan-dg.id
  https_only                = true
  virtual_network_subnet_id = azurerm_subnet.kpa23-webapp-subnet-dg.id
  site_config {
    minimum_tls_version    = "1.2"
    vnet_route_all_enabled = true
    application_stack {
      node_version = "16-lts"
    }
  }
}

# We pulled the app repo from github for our app
resource "azurerm_app_service_source_control" "kpa23-webapp-sourcecontrol-dg" {
  app_id                 = azurerm_linux_web_app.kpa23-webapp-dg.id
  repo_url               = "https://github.com/Azure-Samples/nodejs-docs-hello-world"
  branch                 = "main"
  use_manual_integration = true
  use_mercurial          = false
}