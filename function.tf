resource "azurerm_app_service_plan" "asp" {
  location            = local.location
  resource_group_name = azurerm_resource_group.sample.name
  name                = "asp-func-sample"
  kind                = "elastic"
  reserved            = true

  sku {
    tier = "ElasticPremium"
    size = "EP1"
  }
}

resource "azurerm_storage_account" "storage" {
  location                 = local.location
  resource_group_name      = azurerm_resource_group.sample.name
  name                     = "sajokafuncsample"
  account_tier             = "Standard"
  account_kind             = "StorageV2"
  account_replication_type = "LRS"
}

resource "azurerm_function_app" "func" {
  location                   = local.location
  resource_group_name        = azurerm_resource_group.sample.name
  name                       = "joka-func-sample"
  app_service_plan_id        = azurerm_app_service_plan.asp.id
  storage_account_name       = azurerm_storage_account.storage.name
  storage_account_access_key = azurerm_storage_account.storage.primary_access_key
  os_type                    = "linux"
  version                    = "~4"

  site_config {
    use_32_bit_worker_process = false
    vnet_route_all_enabled    = true
    dotnet_framework_version  = "v6.0"
  }

  app_settings = {
    "FUNCTIONS_WORKER_RUNTIME" = "dotnet"
  }
}

resource "azurerm_app_service_virtual_network_swift_connection" "funcvnetintegration" {
  app_service_id = azurerm_function_app.func.id
  subnet_id      = azurerm_subnet.func.id
}
