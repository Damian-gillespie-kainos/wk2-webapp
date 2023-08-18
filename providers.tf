# Stating the version of terraform to be used
terraform {
  required_version = ">=1.5"

# Add the providers necessary for this project 
  required_providers {
    azurerm = {                       # Using Azure to build out the services
      source  = "hashicorp/azurerm"
      version = "3.69.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
    tls = {                          # TLS for keys
      source  = "hashicorp/tls"
      version = "~>4.0"
    }
    local = {                        # Not used in this project as we stored the keys in a key vault on Azure. Local can be used to place keys in a selected local directory
      source  = "hashicorp/local"
      version = "~>2.4"
    }
  }
}

provider "azurerm" {                 # Here we are identifying specific features of Azurerm relating to the key vault. 
  features {
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
  }
}