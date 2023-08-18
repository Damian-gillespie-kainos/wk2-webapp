# To set up a Bastion we need a public IP 
# PUBLIC IP
resource "azurerm_public_ip" "kpa23-public-ip-dg" {
  name                = "kpa23-public-ip-dg"
  location            = azurerm_resource_group.kpa23-rg-dg.location
  resource_group_name = azurerm_resource_group.kpa23-rg-dg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}



# Creating the BASTION
resource "azurerm_bastion_host" "kpa23-bastion-host-dg" {
  name                = "kpa23-bastion-host-dg"
  location            = azurerm_resource_group.kpa23-rg-dg.location
  resource_group_name = azurerm_resource_group.kpa23-rg-dg.name

  ip_configuration {
    name                 = "kpa23-bastion-ip-dg"
    subnet_id            = azurerm_subnet.kpa23-bastionsubnet-dg.id
    public_ip_address_id = azurerm_public_ip.kpa23-public-ip-dg.id
  }
}
