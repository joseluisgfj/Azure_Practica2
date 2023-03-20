resource "azurerm_resource_group" "jlgf" {
  name     = var.resource_group_name
  location = var.location_name
}

resource "azurerm_virtual_network" "vnet" {
  name                = var.network_name
  address_space       = ["20.0.0.0/16"]
  location            = azurerm_resource_group.jlgf.location
  resource_group_name = azurerm_resource_group.jlgf.name
}

resource "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.jlgf.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["20.0.2.0/24"]
}

resource "azurerm_network_interface" "nic" {
  name                = "vnic"
  location            = azurerm_resource_group.jlgf.location
  resource_group_name = azurerm_resource_group.jlgf.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "20.0.2.4"
    public_ip_address_id          = azurerm_public_ip.pip.id
  }
}

resource "azurerm_public_ip" "pip" {
  name                = "VIP"
  location            = azurerm_resource_group.jlgf.location
  resource_group_name = azurerm_resource_group.jlgf.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                = "vm01"
  resource_group_name = azurerm_resource_group.jlgf.name
  location            = azurerm_resource_group.jlgf.location
  size                = "Standard_F2"
  admin_username      = "azureuser"
  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]

  admin_ssh_key {
    username   = "azureuser"
    public_key = file("/home/practica2/keys/azure.pub")
  }
  
	  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  plan {
    name      = "centos-8-stream-free"
    product   = "centos-8-stream-free"
    publisher = "cognosys"
  }

  source_image_reference {
    publisher = "cognosys"
    offer     = "centos-8-stream-free"
    sku       = "centos-8-stream-free"
    version   = "22.03.28"
  }
}
  
# Create Network Security Group and rule
resource "azurerm_network_security_group" "jlgf_ssh" {
  name                = "myNetworkSecurityGroup"
  location            = azurerm_resource_group.jlgf.location
  resource_group_name = azurerm_resource_group.jlgf.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"	
	}
	security_rule {
    name                       = "http"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = "*"
    destination_address_prefix = "*"	  
    }
}	
	
resource "azurerm_subnet_network_security_group_association" "jlgf_ssh" {
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.jlgf_ssh.id
}


