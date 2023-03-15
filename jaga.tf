# Create a virtual network for the VM
resource "azurerm_virtual_network" "pavan_vnet" {
  name                = "nagendra-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.pavan_rg.location
  resource_group_name = azurerm_resource_group.pavan_rg.name
}

# Create a subnet for the VM
resource "azurerm_subnet" "pavan_subnet" {
  name                 = "nagendra_subnet"
  resource_group_name  = azurerm_resource_group.pavan_rg.name
  virtual_network_name = azurerm_virtual_network.pavan_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Create a public IP address for the VM
resource "azurerm_public_ip" "pavan_pip" {
  name                = "nagendra-pip"
  location            = azurerm_resource_group.pavan_rg.location
  resource_group_name = azurerm_resource_group.pavan_rg.name
  allocation_method   = "Static"
}

# Create a network interface for the VM
resource "azurerm_network_interface" "pavan_nic" {
  name                = "nagebdra-nic"
  location            = azurerm_resource_group.pavan_rg.location
  resource_group_name = azurerm_resource_group.pavan_rg.name

  ip_configuration {
    name                          = "example-config"
    subnet_id                     = azurerm_subnet.pavan_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pavan_pip.id
  }
}

# Create a virtual machine
resource "azurerm_virtual_machine" "pavan_vm" {
  name                  = "nagendra-vm"
  location              = azurerm_resource_group.pavan_rg.location
  resource_group_name   = azurerm_resource_group.pavan_rg.name
  network_interface_ids = [azurerm_network_interface.pavan_nic.id]

  vm_size              = "Standard_B2s"
  delete_os_disk_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "example-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "nagendra-vm"
    admin_username = "adminuser"
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path     = "/home/adminuser/.ssh/authorized_keys"
      key_data = "ssh-rsa <your-ssh-public-key>"
    }
  }
}
# Create a NSG for the VM
resource "azurerm_network_security_group" "pavan_nsg" {
  name                = "nagendra_nsg"
  location            = azurerm_resource_group.pavan_rg.location
  resource_group_name = azurerm_resource_group.pavan_rg.name
  

  security_rule {
    name                       = "test123"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "10.0.2.0/24"
  }

  tags = {
    environment = "Production"
  }
}