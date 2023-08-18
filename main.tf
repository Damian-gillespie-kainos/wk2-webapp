# Setting up the resource group for this project

resource "azurerm_resource_group" "kpa23-rg-dg" {
  name     = "kpa23-rg-dg"
  location = "eastus"
}

data "azurerm_client_config" "current" {}             # Need this line to get tenant ID whic is needed for various services



# Setting up a VNET, then the private DNS and linking it to the VNET

resource "azurerm_private_dns_zone" "kpa23-pdns-dg" {                             # (2) Set up private DNS zone
  name                = "dgwebapp.com"
  resource_group_name = azurerm_resource_group.kpa23-rg-dg.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "kpa23-vnlink-dg" {      # (3) Link the priavte DNS and VNET
  name                  = "kpa23-vnlink-dg"
  resource_group_name   = azurerm_resource_group.kpa23-rg-dg.name
  private_dns_zone_name = azurerm_private_dns_zone.kpa23-pdns-dg.name
  virtual_network_id    = azurerm_virtual_network.kpa23-vn-dg.id
}

resource "azurerm_virtual_network" "kpa23-vn-dg" {                                # (1) Set up the VNET
  name                = "kpa23-vn-dg"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.kpa23-rg-dg.location
  resource_group_name = azurerm_resource_group.kpa23-rg-dg.name
}



# The SUBNETS of the VNET

# SUBNET WEBAPP
# We need to "delegate" this subnet to 'server farm' to be used for the webapp. Essentially stating that this subnet will be used to host the app service plan.
resource "azurerm_subnet" "kpa23-webapp-subnet-dg" {
  name                 = "kpa23-webapp-subnet-dg"
  resource_group_name  = azurerm_resource_group.kpa23-rg-dg.name
  address_prefixes     = ["10.0.1.0/24"]
  virtual_network_name = azurerm_virtual_network.kpa23-vn-dg.name
  delegation {
    name = "kpa23-webapp-subnet-delegation-dg"
    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action", "Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }
}


# SUBNET KEYVAULT
resource "azurerm_subnet" "kpa23-keyvault-subnet-dg" {
  name                 = "kpa23-keyvault-subnet-dg"
  resource_group_name  = azurerm_resource_group.kpa23-rg-dg.name
  address_prefixes     = ["10.0.3.0/24"]
  virtual_network_name = azurerm_virtual_network.kpa23-vn-dg.name
  service_endpoints    = ["Microsoft.Keyvault"]
}

# SUBNET DB POSTGRESQL
resource "azurerm_subnet" "kpa23-db-subnet-dg" {
  name                 = "kpa23-db-subnet-dg"
  resource_group_name  = azurerm_resource_group.kpa23-rg-dg.name
  address_prefixes     = ["10.0.2.0/24"]
  virtual_network_name = azurerm_virtual_network.kpa23-vn-dg.name

  enforce_private_link_service_network_policies = true            # Needed to apply the private endpoint
}

# SUBNET BASTION
resource "azurerm_subnet" "kpa23-bastionsubnet-dg" {
  name                 = "AzureBastionSubnet"                     # Must be name this
  resource_group_name  = azurerm_resource_group.kpa23-rg-dg.name
  virtual_network_name = azurerm_virtual_network.kpa23-vn-dg.name
  address_prefixes     = ["10.0.4.0/24"]                          # Must me /26 or higher
}




# Setting up private endpoint for POSTGRESQL
resource "azurerm_private_endpoint" "kpa23-endpoint-dg" {
  name                = "kpa23-endpoint-dg"
  location            = azurerm_resource_group.kpa23-rg-dg.location
  resource_group_name = azurerm_resource_group.kpa23-rg-dg.name
  subnet_id           = azurerm_subnet.kpa23-db-subnet-dg.id

  private_service_connection {
    name                           = "kpa23-private-service-connection-dg"
    private_connection_resource_id = azurerm_postgresql_server.kpa23-postgresql-server-dg.id
    subresource_names              = ["postgresqlServer"]   # Very important to spell this right or it gives a 400 error to the resource
    is_manual_connection           = false
  }
}




# Setting up a SG
# May not be needed here as we set up a bastion and a keyvault 
resource "azurerm_network_security_group" "kpa23-nsg-dg" {
  name                = "kpa23-nsg-dg"
  location            = azurerm_resource_group.kpa23-rg-dg.location
  resource_group_name = azurerm_resource_group.kpa23-rg-dg.name
}

