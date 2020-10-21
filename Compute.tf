resource "azurerm_resource_group" "compute-vm" {
  name                                  = "lvs-lab-compute-rg"
  location                              = var.location

  tags                                  = var.tags
}

locals {
  vm-name1 = "${var.vm_name}-01-${random_string.random.result}"
  vm-name2 = "${var.vm_name}-02-${random_string.random.result}"
}


resource "azurerm_network_interface" "compute-vm1" {
  name                                  = "${local.vm-name1}-nic0"
  location                              = azurerm_resource_group.compute-vm.location
  resource_group_name                   = azurerm_resource_group.compute-vm.name

  ip_configuration {
    name                                = "ipconfig1"
    subnet_id                           = azurerm_subnet.prod.id
    private_ip_address_allocation       = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "compute-vm1" {
  name                                  = local.vm-name1
  location                              = azurerm_resource_group.compute-vm.location
  resource_group_name                   = azurerm_resource_group.compute-vm.name
  network_interface_ids                 = [azurerm_network_interface.compute-vm1.id]
  vm_size                               = "Standard_B2ms"

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
	  offer = "WindowsServer"
	  sku = "2016-Datacenter"
	  version = "latest"
  }

  storage_os_disk {
    name              =  "${local.vm-name1}-disk-01"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
    disk_size_gb      = 127
  }
  
  os_profile {
    computer_name  = local.vm-name1
    admin_username = "azadmin"
    admin_password = random_password.password.result
  }

  os_profile_windows_config {
    provision_vm_agent = true
    enable_automatic_upgrades = false
  }
}


resource "azurerm_managed_disk" "compute-vm" {
  name = "${azurerm_virtual_machine.compute-vm1.name}-disk-02"
  location = azurerm_resource_group.compute-vm.location
  resource_group_name = azurerm_resource_group.compute-vm.name
  storage_account_type = "Standard_LRS"
  create_option = "Empty"
  disk_size_gb = 127
}

resource "azurerm_virtual_machine_data_disk_attachment" "compute-vm" {
  managed_disk_id = azurerm_managed_disk.compute-vm.id
  virtual_machine_id = azurerm_virtual_machine.compute-vm1.id
  lun = 0
  caching = "None"
}


resource "azurerm_managed_disk" "compute-vm-disk1" {
  name = "${azurerm_virtual_machine.compute-vm1.name}-disk-03"
  location = azurerm_resource_group.compute-vm.location
  resource_group_name = azurerm_resource_group.compute-vm.name
  storage_account_type = "Standard_LRS"
  create_option = "Empty"
  disk_size_gb = 127
}

resource "azurerm_managed_disk" "compute-vm-disk2" {
  name = "${azurerm_virtual_machine.compute-vm1.name}-temp"
  location = "eastus2"
  resource_group_name = azurerm_resource_group.compute-vm.name
  storage_account_type = "Standard_LRS"
  create_option = "Empty"
  disk_size_gb = 127
}

resource "azurerm_managed_disk" "compute-vm-disk3" {
  name = "${azurerm_virtual_machine.compute-vm1.name}-${random_string.random.result}"
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






#######

#Vm2



resource "azurerm_network_interface" "compute-vm2" {
  name                                  = "${local.vm-name2}-nic0"
  location                              = azurerm_resource_group.compute-vm.location
  resource_group_name                   = azurerm_resource_group.compute-vm.name

  ip_configuration {
    name                                = "ipconfig1"
    subnet_id                           = azurerm_subnet.prod.id
    private_ip_address_allocation       = "Dynamic"
    public_ip_address_id                = azurerm_public_ip.compute-vm2.id
  }
}

resource "azurerm_network_security_group" "compute-vm2" {
    name                = "${local.vm-name2}-nic0"
    location            = azurerm_resource_group.compute-vm.location
    resource_group_name = azurerm_resource_group.compute-vm.name

    #Provision a security rule with your current IP as a source filter
    security_rule {
        name                       = "RDP"
        priority                   = 1000
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "3389"
        source_address_prefix      = chomp(data.http.myip.body)
        destination_address_prefix = "*"
    }
}

resource "azurerm_network_interface_security_group_association" "compute-vm2" {
  network_interface_id      = azurerm_network_interface.compute-vm2.id
  network_security_group_id = azurerm_network_security_group.compute-vm2.id
}

resource "azurerm_public_ip" "compute-vm2" {
  name                = "acceptanceTestPublicIp1"
  resource_group_name = azurerm_resource_group.compute-vm.name
  location            = azurerm_resource_group.compute-vm.location
  allocation_method   = "Static"
}

resource "azurerm_virtual_machine" "compute-vm2" {
  name                                  = local.vm-name2
  location                              = "eastus2"
  resource_group_name                   = azurerm_resource_group.compute-vm.name
  network_interface_ids                 = [azurerm_network_interface.compute-vm1.id]
  vm_size                               = "Standard_B2ms"

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
	  offer = "WindowsServer"
	  sku = "2016-Datacenter"
	  version = "latest"
  }

  storage_os_disk {
    name              =  "${local.vm-name2}-disk-01"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
    disk_size_gb      = 127
  }
  
  os_profile {
    computer_name  = local.vm-name2
    admin_username = "azadmin"
    admin_password = random_password.password.result
  }

  os_profile_windows_config {
    provision_vm_agent = true
    enable_automatic_upgrades = false
  }
}


resource "azurerm_managed_disk" "compute-vm2" {
  name = "${azurerm_virtual_machine.compute-vm1.name}-disk-02"
  location = azurerm_resource_group.compute-vm.location
  resource_group_name = azurerm_resource_group.compute-vm.name
  storage_account_type = "Standard_LRS"
  create_option = "Empty"
  disk_size_gb = 127
}