resource "azurerm_resource_group" "compute-vm" {
  name                                  = "lvs-lab-compute-rg"
  location                              = var.location

  tags                                  = var.tags
}


locals {
  vm-name = "${var.vm_name}-${random_string.random.result}"
}


resource "azurerm_network_interface" "compute-vm" {
  name                                  = "${local.vm-name}-nic0"
  location                              = azurerm_resource_group.compute-vm.location
  resource_group_name                   = azurerm_resource_group.compute-vm.name

  ip_configuration {
    name                                = "ipconfig1"
    subnet_id                           = azurerm_subnet.prod.id
    private_ip_address_allocation       = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "compute-vm" {
  name                                  = local.vm-name
  location                              = azurerm_resource_group.compute-vm.location
  resource_group_name                   = azurerm_resource_group.compute-vm.name
  network_interface_ids                 = [azurerm_network_interface.compute-vm.id]
  vm_size                               = "Standard_B2ms"

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
	  offer = "WindowsServer"
	  sku = "2016-Datacenter"
	  version = "latest"
  }

  storage_os_disk {
    name              =  "${local.vm-name}-disk-01"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
    disk_size_gb      = 127
  }
  
  os_profile {
    computer_name  = local.vm-name
    admin_username = "azadmin"
    admin_password = random_password.password.result
  }

  os_profile_windows_config {
    provision_vm_agent = true
    enable_automatic_upgrades = false
  }
}


resource "azurerm_managed_disk" "compute-vm" {
  name = "${azurerm_virtual_machine.compute-vm.name}-disk-02"
  location = azurerm_resource_group.compute-vm.location
  resource_group_name = azurerm_resource_group.compute-vm.name
  storage_account_type = "Standard_LRS"
  create_option = "Empty"
  disk_size_gb = 127
}

resource "azurerm_virtual_machine_data_disk_attachment" "compute-vm" {
  managed_disk_id = azurerm_managed_disk.compute-vm.id
  virtual_machine_id = azurerm_virtual_machine.compute-vm.id
  lun = 0
  caching = "None"
}


resource "azurerm_managed_disk" "compute-vm-disk1" {
  name = "${azurerm_virtual_machine.compute-vm.name}-disk-03"
  location = azurerm_resource_group.compute-vm.location
  resource_group_name = azurerm_resource_group.compute-vm.name
  storage_account_type = "Standard_LRS"
  create_option = "Empty"
  disk_size_gb = 127
}

resource "azurerm_managed_disk" "compute-vm-disk2" {
  name = "${azurerm_virtual_machine.compute-vm.name}-temp"
  location = "eastus2"
  resource_group_name = azurerm_resource_group.compute-vm.name
  storage_account_type = "Standard_LRS"
  create_option = "Empty"
  disk_size_gb = 127
}

resource "azurerm_managed_disk" "compute-vm-disk3" {
  name = "${azurerm_virtual_machine.compute-vm.name}-${random_string.random.result}"
  location = "westeurope"
  resource_group_name = azurerm_resource_group.compute-vm.name
  storage_account_type = "Standard_LRS"
  create_option = "Empty"
  disk_size_gb = 127
}

resource "azurerm_managed_disk" "compute-vm-disk4" {
  name = "Temporary-00-${random_string.random.result}"
  location = "canadacentral"
  resource_group_name = azurerm_resource_group.compute-vm.name
  storage_account_type = "Premium_LRS"
  create_option = "Empty"
  disk_size_gb = 14
}

resource "azurerm_network_interface" "compute-vm-random" {
  name                                  = "vm00-nic0"
  location                              = azurerm_resource_group.compute-vm.location
  resource_group_name                   = azurerm_resource_group.compute-vm.name

  ip_configuration {
    name                                = "ipconfig1"
    subnet_id                           = azurerm_subnet.prod.id
    private_ip_address_allocation       = "Dynamic"
  }
}


resource "azurerm_network_interface" "compute-vm-random1" {
  name                                  = "vm00-${random_string.random.result}-nic0"
  location                              = azurerm_resource_group.compute-vm.location
  resource_group_name                   = azurerm_resource_group.compute-vm.name

  ip_configuration {
    name                                = "ipconfig1"
    subnet_id                           = azurerm_subnet.prod.id
    private_ip_address_allocation       = "Dynamic"
  }
}

resource "azurerm_network_interface" "compute-vm-random2" {
  name                                  = "vm00-${random_string.random.result}-nic1"
  location                              = azurerm_resource_group.compute-vm.location
  resource_group_name                   = azurerm_resource_group.compute-vm.name

  ip_configuration {
    name                                = "ipconfig1"
    subnet_id                           = azurerm_subnet.dev.id
    private_ip_address_allocation       = "Dynamic"
  }
}