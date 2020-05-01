###########################################################################
## Terraform script to create Windows VM and dependent resources in Azure
###########################################################################

#########################################################
## Create Resource Group
#########################################################
resource "azurerm_resource_group" "vm" {
  name     = "demorg"
  location = var.location
}

#########################################################
## Create VNet
#########################################################
module "vnet" {
  source              = "github.com/dipesharora/terraform-azure-vnet"
  resource_group_name = azurerm_resource_group.vm.name
  location            = var.location
  vnet_name           = var.vnet_name
  vnet_address_space  = var.vnet_address_space
  tags = {
    Environment = "Test"
    Application = "Test App"
  }
}

#########################################################
## Create Subnet
#########################################################
module "subnet" {
  source                = "github.com/dipesharora/terraform-azure-subnet"
  resource_group_name   = azurerm_resource_group.vm.name
  vnet_name             = module.vnet.vnet_name_output
  subnet_name           = var.subnet_name
  subnet_address_prefix = var.subnet_address_prefix
}

#########################################################
## Create Network Security Group
#########################################################
module "nsg" {
  source              = "github.com/dipesharora/terraform-azure-nsg"
  resource_group_name = azurerm_resource_group.vm.name
  location            = var.location
  nsg_name            = var.nsg_name
  tags = {
    Environment = "Test"
    Application = "Test App"
  }
}

#########################################################
## Create Network Security Group and Subnet Association
#########################################################
module "subnet-nsg-association" {
  source    = "github.com/dipesharora/terraform-azure-subnet-nsg-association"
  subnet_id = module.subnet.subnet_id_output
  nsg_id    = module.nsg.nsg_id_output
}

########################################################
# Create Network Security Rules for Windows VMs
########################################################
module "nsgrule_HTTP_Port_80" {
  source                              = "github.com/dipesharora/terraform-azure-nsg-rule"
  resource_group_name                 = azurerm_resource_group.vm.name
  nsg_name                            = module.nsg.nsg_name_output
  nsg_rule_status                     = var.nsg_rule_http_port_80_status
  nsg_rule_name                       = "HTTP_Port_80"
  nsg_rule_priority                   = 100
  nsg_rule_direction                  = "Inbound"
  nsg_rule_access                     = "Allow"
  nsg_rule_protocol                   = "Tcp"
  nsg_rule_source_address_prefix      = var.nsg_rule_http_port_80_source_address
  nsg_rule_source_port_range          = "*"
  nsg_rule_destination_address_prefix = var.nsg_rule_http_port_80_destination_address
  nsg_rule_destination_port_range     = "80"
  nsg_rule_description                = "Allow HTTP Traffic on Port 80."
}

module "nsgrule_HTTPS_Port_443" {
  source                              = "github.com/dipesharora/terraform-azure-nsg-rule"
  resource_group_name                 = azurerm_resource_group.vm.name
  nsg_name                            = module.nsg.nsg_name_output
  nsg_rule_status                     = var.nsg_rule_https_port_443_status
  nsg_rule_name                       = "HTTPS_Port_443"
  nsg_rule_priority                   = 110
  nsg_rule_direction                  = "Inbound"
  nsg_rule_access                     = "Allow"
  nsg_rule_protocol                   = "Tcp"
  nsg_rule_source_address_prefix      = var.nsg_rule_https_port_443_source_address
  nsg_rule_source_port_range          = "*"
  nsg_rule_destination_address_prefix = var.nsg_rule_https_port_443_destination_address
  nsg_rule_destination_port_range     = "443"
  nsg_rule_description                = "Allow HTTPS Traffic on Port 443."
}

module "nsgrule_RDP_Port_3389" {
  source                              = "github.com/dipesharora/terraform-azure-nsg-rule"
  resource_group_name                 = azurerm_resource_group.vm.name
  nsg_name                            = module.nsg.nsg_name_output
  nsg_rule_status                     = var.nsg_rule_rdp_port_3389_status
  nsg_rule_name                       = "RDP_Port_3389"
  nsg_rule_priority                   = 1000
  nsg_rule_direction                  = "Inbound"
  nsg_rule_access                     = "Allow"
  nsg_rule_protocol                   = "Tcp"
  nsg_rule_source_address_prefix      = var.nsg_rule_rdp_port_3389_source_address
  nsg_rule_source_port_range          = "*"
  nsg_rule_destination_address_prefix = var.nsg_rule_rdp_port_3389_destination_address
  nsg_rule_destination_port_range     = "3389"
  nsg_rule_description                = "Allow RDP on Port 3389."
}

#########################################################
## Create Windows VM & dependent resources
#########################################################
module "diags_storage_account" {
  source                               = "github.com/dipesharora/terraform-azure-storage-account"
  location                             = var.location
  resource_group_name                  = azurerm_resource_group.vm.name
  storage_account_name                 = "${var.vm_prefix}diag"
  storage_account_tier                 = var.storage_account_tier
  storage_account_replication_type     = var.storage_account_replication_type
  storage_account_enable_https_traffic = var.storage_account_enable_https_traffic
  tags = {
    Environment = "Test"
    Application = "Test App"
  }
}

module "windowsvm" {
  source                              = "github.com/dipesharora/terraform-azure-windows-vm"
  location                            = var.location
  resource_group_name                 = azurerm_resource_group.vm.name
  nic_subnet_id                       = module.subnet.subnet_id_output
  vm_count                            = var.vm_count
  vm_prefix                           = var.vm_prefix
  vm_size                             = var.vm_size
  vm_delete_os_disk_on_termination    = var.vm_delete_os_disk_on_termination
  vm_delete_data_disks_on_termination = var.vm_delete_data_disks_on_termination
  vm_os_disk_caching                  = var.vm_os_disk_caching
  vm_os_disk_create_option            = var.vm_os_disk_create_option
  vm_os_disk_storage_account_type     = var.vm_os_disk_storage_account_type
  vm_os_disk_size                     = var.vm_os_disk_size
  vm_agent                            = var.vm_agent
  vm_timezone                         = var.vm_timezone
  vm_boot_diagnostics_enabled         = var.vm_boot_diagnostics_enabled
  vm_boot_diagnostics_storage_uri     = module.diags_storage_account.storage_account_primary_blob_endpoint_output
  vm_image_publisher                  = var.vm_image_publisher
  vm_image_offer                      = var.vm_image_offer
  vm_image_sku                        = var.vm_image_sku
  vm_image_version                    = var.vm_image_version
  vm_admin_username                   = var.vm_admin_username
  vm_admin_password                   = var.vm_admin_password
  vm_data_disk_size_list              = var.vm_data_disk_size_list
  vm_data_disk_storage_account_type   = var.vm_data_disk_storage_account_type
  vm_data_disk_create_option          = var.vm_data_disk_create_option
  vm_data_disk_caching                = var.vm_data_disk_caching
  tags = {
    Environment = "Test"
    Application = "Test App"
  }
}