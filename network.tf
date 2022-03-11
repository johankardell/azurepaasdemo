resource "azurerm_virtual_network" "sample" {
  location            = local.location
  name                = "vnet-func-sample"
  resource_group_name = azurerm_resource_group.sample.name
  address_space       = ["192.168.0.0/23"]
}

resource "azurerm_subnet" "iaas" {
  name                 = "subnet-iaas"
  resource_group_name  = azurerm_resource_group.sample.name
  virtual_network_name = azurerm_virtual_network.sample.name
  address_prefixes     = ["192.168.0.0/26"]
  
  service_endpoints = ["Microsoft.AzureCosmosDB"]
}

resource "azurerm_subnet" "func" {
  name                 = "subnet-function"
  resource_group_name  = azurerm_resource_group.sample.name
  virtual_network_name = azurerm_virtual_network.sample.name
  address_prefixes     = ["192.168.0.64/26"]

  delegation {
    name = "delegation-func"

    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }

  service_endpoints = ["Microsoft.AzureCosmosDB"]
}

resource "azurerm_subnet" "aci" {
  name                 = "subnet-aci"
  resource_group_name  = azurerm_resource_group.sample.name
  virtual_network_name = azurerm_virtual_network.sample.name
  address_prefixes     = ["192.168.0.128/26"]

  delegation {
    name = "delegation-aci"

    service_delegation {
      name    = "Microsoft.ContainerInstance/containerGroups"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }

  service_endpoints = ["Microsoft.AzureCosmosDB"]
}

resource "azurerm_subnet_network_security_group_association" "iaas" {
  subnet_id                 = azurerm_subnet.iaas.id
  network_security_group_id = azurerm_network_security_group.iaas.id
}

resource "azurerm_network_security_group" "iaas" {
  name                = "nsg-iaas"
  location            = azurerm_resource_group.sample.location
  resource_group_name = azurerm_resource_group.sample.name

  security_rule {
    name                       = "ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "185.213.154.230"
    destination_address_prefix = "*"
  }
}
