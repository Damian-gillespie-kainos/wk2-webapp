# this is the server for hosting our DB 
resource "azurerm_postgresql_server" "kpa23-postgresql-server-dg" {
  name                = "kpa23-postgresql-server-dg"
  location            = azurerm_resource_group.kpa23-rg-dg.location
  resource_group_name = azurerm_resource_group.kpa23-rg-dg.name

  administrator_login          = "postadmindg"     # Remember you username and passwords
  administrator_login_password = "H@Sh1CoR3!"

  sku_name   = "GP_Gen5_4"
  version    = "11"
  storage_mb = 640000

  backup_retention_days        = 7
  geo_redundant_backup_enabled = true
  auto_grow_enabled            = true

  public_network_access_enabled    = false
  ssl_enforcement_enabled          = true
  ssl_minimal_tls_version_enforced = "TLS1_2"
}

# This is our actual DB linked to the above server
resource "azurerm_postgresql_database" "kpa23-postgresql-dg" {
  name                = "kpa23-postgresql-dg"
  resource_group_name = azurerm_resource_group.kpa23-rg-dg.name
  server_name         = azurerm_postgresql_server.kpa23-postgresql-server-dg.name
  charset             = "UTF8"
  collation           = "English_United States.1252"
}