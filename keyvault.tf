resource "azurerm_key_vault" "kpa23-keyvault-dg" {
  name                     = "kpa23-keyvault-dg"
  location                 = azurerm_resource_group.kpa23-rg-dg.location
  resource_group_name      = azurerm_resource_group.kpa23-rg-dg.name
  tenant_id                = data.azurerm_client_config.current.tenant_id
  sku_name                 = "standard"
  purge_protection_enabled = false

}

resource "azurerm_key_vault_access_policy" "kpa23-kv-access-policy-dg" {
  key_vault_id = azurerm_key_vault.kpa23-keyvault-dg.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  key_permissions = [
    "Create",
    "Delete",
    "Get",
    "Purge",
    "Recover",
    "Update",
    "GetRotationPolicy",
    "SetRotationPolicy"
  ]

  secret_permissions = [
    "Get", "Backup", "Delete", "List", "Recover", "Purge", "Restore", "Set"
  ]
}

resource "azurerm_key_vault_key" "kpa23-keyvault-key2-dg" {
  name         = "kpa23-keyvalult-key2-dg"
  key_vault_id = azurerm_key_vault.kpa23-keyvault-dg.id
  key_type     = "RSA"
  key_size     = 2048

  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey",
  ]

  rotation_policy {
    automatic {
      time_before_expiry = "P30D"
    }

    expire_after         = "P90D"
    notify_before_expiry = "P29D"
  }
}