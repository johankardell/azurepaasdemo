resource "azurerm_container_group" "container" {
  name                = "joka-aci-sample"
  location            = local.location
  resource_group_name = azurerm_resource_group.sample.name
  ip_address_type     = "Private"
  os_type             = "Linux"
  network_profile_id  = azurerm_network_profile.aci.id

  container {
    name  = "hello-world"
    image = "mcr.microsoft.com/azuredocs/azure-vote-front:cosmosdb"
    # image  = "mcr.microsoft.com/azuredocs/aci-helloworld:latest"
    cpu    = "0.5"
    memory = "1.5"

    ports {
      port     = 80
      protocol = "TCP"
    }
    environment_variables = {
      "COSMOS_DB_ENDPOINT"  = "${azurerm_cosmosdb_account.dbaccount.endpoint}"
      "COSMOS_DB_MASTERKEY" = "${azurerm_cosmosdb_account.dbaccount.primary_key}"
    }
  }
}

resource "azurerm_network_profile" "aci" {
  name                = "acinetwork"
  location            = azurerm_resource_group.sample.location
  resource_group_name = azurerm_resource_group.sample.name

  container_network_interface {
    name = "acinic"

    ip_configuration {
      name      = "ipconfig"
      subnet_id = azurerm_subnet.aci.id
    }
  }
}
