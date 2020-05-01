#########################################################
## Azure Provider Version 
# whilst the `version` attribute is optional, we recommend pinning to a given version of the Provider. 
#########################################################
provider "azurerm" {
  version = "=2.8.0"
  features {}
}