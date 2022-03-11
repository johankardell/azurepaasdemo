locals {
  location = "westeurope"
}

resource "azurerm_resource_group" "sample" {
  location = local.location
  name     = "func-sample"

  tags = {
    "hidden-sample"  = "true"
    "visible-sample" = "true"
    "environment"    = "dev"
  }
}


output "publicip" {
  value = azurerm_public_ip.ubuntu.ip_address
}
