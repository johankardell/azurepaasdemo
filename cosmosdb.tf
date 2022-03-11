resource "azurerm_cosmosdb_account" "dbaccount" {
  location                          = local.location
  resource_group_name               = azurerm_resource_group.sample.name
  name                              = "jokafuncsampledb"
  offer_type                        = "Standard"
  kind                              = "GlobalDocumentDB"
  enable_automatic_failover         = false
  is_virtual_network_filter_enabled = true
  ip_range_filter                   = "104.42.195.92,40.76.54.131,52.176.6.30,52.169.50.45,52.187.184.26,185.213.154.230" // Azure portal

  consistency_policy {
    consistency_level       = "BoundedStaleness"
    max_interval_in_seconds = 300
    max_staleness_prefix    = 100000
  }

  geo_location {
    location          = "westeurope"
    failover_priority = 0
  }

  virtual_network_rule {
    id = azurerm_subnet.func.id

  }
  virtual_network_rule {
    id = azurerm_subnet.aci.id
  }
  virtual_network_rule {
    id = azurerm_subnet.iaas.id
  }
}

# resource "azurerm_cosmosdb_sql_database" "sqldb" {
#   name                = "sqldb"
#   resource_group_name = azurerm_cosmosdb_account.dbaccount.resource_group_name
#   account_name        = azurerm_cosmosdb_account.dbaccount.name
#   throughput          = 400
# }

# resource "azurerm_cosmosdb_sql_container" "container" {
#   name                  = "sample-container"
#   resource_group_name   = azurerm_cosmosdb_account.dbaccount.resource_group_name
#   account_name          = azurerm_cosmosdb_account.dbaccount.name
#   database_name         = azurerm_cosmosdb_sql_database.sqldb.name
#   partition_key_path    = "/definition/id"
#   partition_key_version = 1
#   throughput            = 400

#   indexing_policy {
#     indexing_mode = "Consistent"

#     included_path {
#       path = "/*"
#     }

#     included_path {
#       path = "/included/?"
#     }

#     excluded_path {
#       path = "/excluded/?"
#     }
#   }

#   unique_key {
#     paths = ["/definition/idlong", "/definition/idshort"]
#   }
# }
