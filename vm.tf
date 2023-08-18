resource "azurerm_network_interface" "kpa23-nic-dg" {
  name                = "kpa23-nic-dg"
  location            = azurerm_resource_group.kpa23-rg-dg.location
  resource_group_name = azurerm_resource_group.kpa23-rg-dg.name

  ip_configuration {
    name                          = "kpa23-nic-ip-config-dg"
    subnet_id                     = azurerm_subnet.kpa23-db-subnet-dg.id
    private_ip_address_allocation = "Dynamic"
  }
}

data "azurerm_key_vault" "kpa23-keyvault-dg" {
  name                = "kpa23-keyvault-dg"
  resource_group_name = azurerm_resource_group.kpa23-rg-dg.name
}

data "azurerm_key_vault_secret" "ssh_public_key" {
  name         = "ssh-public-dg"
  key_vault_id = data.azurerm_key_vault.kpa23-keyvault-dg.id
}

resource "azurerm_linux_virtual_machine" "kpa23-vm-dg" {
  name                = "kpa23-vm-dg"
  resource_group_name = azurerm_resource_group.kpa23-rg-dg.name
  location            = azurerm_resource_group.kpa23-rg-dg.location
  size                = "Standard_DS2_v2"
  admin_username      = "kpa23-dg"
  network_interface_ids = [
    azurerm_network_interface.kpa23-nic-dg.id,
  ]

  admin_ssh_key {
    username   = "kpa23-dg"
    public_key = azurerm_key_vault_secret.kpa23-kv-public-dg.value
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }
}