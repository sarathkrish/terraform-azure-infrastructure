#########################################################
## Variables Declarations
#########################################################

# Shared
variable "location" {
  description = "Set this to the location where your Azure resources will be created e.g. centralus, eastus, eastus2 etc."
}

# Tags
variable "tags" {
  type = object({
    Environment = string
    Application = string
    DisplayName = string
    Purpose     = string
  })
  default = {
    Environment = null
    Application = null
    DisplayName = null
    Purpose     = null
  }
}

# VNet
variable "vnet_name" {
  description = "Set this to the name of the Virtual Network to be created."
}
variable "vnet_address_space" {
  description = "Set this to the address space that will be used in the Virtual Network. This variable accepts list of more than one address space."
}

# Subnets
variable "subnet_name" {
  description = "Set this to the name of the Subnet to be created."
}
variable "subnet_address_prefix" {
  description = "Set this to the address prefix to use for the Subnet."
}

# Network Security Group
variable "nsg_name" {
  description = "Set this to the name of the Network Security Group to be created."
}

# NSG Rules for Subnets
variable "nsg_rule_http_port_80_status" {
  type        = string
  description = "Set this to Enabled if the Network Security rule needs to be created, else set it to Disabled if the Network Security rule does not need to be created."
}
variable "nsg_rule_http_port_80_source_address" {
  type        = string
  description = "Set this to the Source Address for this NSG Rule."
}
variable "nsg_rule_http_port_80_destination_address" {
  type        = string
  description = "Set this to the Destination Address for this NSG Rule."
}
variable "nsg_rule_https_port_443_status" {
  type        = string
  description = "Set this to Enabled if the Network Security rule needs to be created, else set it to Disabled if the Network Security rule does not need to be created."
}
variable "nsg_rule_https_port_443_source_address" {
  type        = string
  description = "Set this to the Source Address for this NSG Rule."
}
variable "nsg_rule_https_port_443_destination_address" {
  type        = string
  description = "Set this to the Destination Address for this NSG Rule."
}
variable "nsg_rule_rdp_port_3389_status" {
  type        = string
  description = "Set this to Enabled if the Network Security rule needs to be created, else set it to Disabled if the Network Security rule does not need to be created."
}
variable "nsg_rule_rdp_port_3389_source_address" {
  type        = string
  description = "Set this to the Source Address for this NSG Rule."
}
variable "nsg_rule_rdp_port_3389_destination_address" {
  type        = string
  description = "Set this to the Destination Address for this NSG Rule."
}

# Storage Account for Diagnostics
variable "storage_account_tier" {
  type        = string
  description = "Set this to the tier to use for this Storage account."
}
variable "storage_account_replication_type" {
  type        = string
  description = "Set this to the type of replication to use for this Storage account."
}
variable "storage_account_enable_https_traffic" {
  type        = string
  description = "Set the boolean flag to enable/disable HTTPS for Storage account."
}

# Network Interface
variable "nic_private_ip_address_allocation_type" {
  type        = string
  description = "Set this to the type of replication to use for this Storage account."
}

# Virtual Machine
variable "vm_count" {
  type        = number
  description = "Set this to the no. of Virtual Machines to be deployed."
}
variable "vm_prefix" {
  type        = string
  description = "Set this to the prefix to be used for VM Name. It will be appended with vm, osdisk etc. while creating the resources."
}
variable "vm_size" {
  type        = string
  description = "Set this to the size of the Virtual Machine. Refer https://docs.microsoft.com/en-us/azure/virtual-machines/windows/sizes."
}
variable "vm_delete_os_disk_on_termination" {
  type        = bool
  description = "Set this to True if the OS Disk should be deleted when the Virtual Machine is destroyed."
}
variable "vm_delete_data_disks_on_termination" {
  type        = bool
  description = "Set this to True if the Data Disks should be deleted when the Virtual Machine is destroyed."
}
variable "vm_os_disk_caching" {
  type        = string
  description = "Set this to the caching requirements for the OS Disk."
}
variable "vm_os_disk_create_option" {
  type        = string
  description = "Set this to how the OS Disk should be created."
}
variable "vm_os_disk_storage_account_type" {
  type        = string
  description = "Set this to the type of managed disk to create."
}
variable "vm_os_disk_size" {
  type        = number
  description = "Set this to the size of the OS Disk in gigabytes."
}
variable "vm_agent" {
  type        = bool
  description = "Set this to True if Azure Virtual Machine Guest Agent should be installed on the Virtual Machine."
}
variable "vm_timezone" {
  type        = string
  description = "Set this to the time zone of the Virtual Machine to be created."
}
variable "vm_boot_diagnostics_enabled" {
  type        = bool
  description = "Set this to True if boot diagnostics need to be enabled on the Virtual Machine."
}
variable "vm_image_publisher" {
  type        = string
  description = "Set this to the publisher of the image used to create the virtual machine."
}
variable "vm_image_offer" {
  type        = string
  description = "Set this to the offer of the image used to create the virtual machine."
}
variable "vm_image_sku" {
  type        = string
  description = "Set this to the SKU of the image used to create the virtual machine."
}
variable "vm_image_version" {
  type        = string
  description = "Set this to the version of the image used to create the virtual machine."
}
variable "vm_admin_username" {
  type        = string
  description = "Set this to the name of the local administrator account on the VM."
}
variable "vm_admin_password" {
  type        = string
  description = "Set this to the password associated with the local administrator account on the VM."
}

#Managed Drives
variable "vm_data_disk_size_list" {
  type        = list
  description = "Set this to the list of sizes of the Data disks."
}
variable "vm_data_disk_storage_account_type" {
  type        = string
  description = "Set this to the type of managed disk to create."
}
variable "vm_data_disk_create_option" {
  type        = string
  description = "Set this to how the Data Disk should be created."
}
variable "vm_data_disk_caching" {
  type        = string
  description = "Set this to the caching requirements for the Data Disk."
}