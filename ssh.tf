# We used TLS to create the key
resource "tls_private_key" "kpa23-keygen-dg" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# First key secret - we pull the public key and create the key vault secret
resource "azurerm_key_vault_secret" "kpa23-kv-public-dg" {
  name         = "ssh-public-dg"
  value        = tls_private_key.kpa23-keygen-dg.public_key_openssh
  key_vault_id = azurerm_key_vault.kpa23-keyvault-dg.id
}

# Second key secret - we do the same for the private key
resource "azurerm_key_vault_secret" "kpa23-kv-private-dg" {
  name         = "ssh-private-dg"
  value        = tls_private_key.kpa23-keygen-dg.private_key_pem
  key_vault_id = azurerm_key_vault.kpa23-keyvault-dg.id
}
