terraform {
  required_providers { azurerm = { source="hashicorp/azurerm", version=">= 3.115.0" } }
}
provider "azurerm" { features {} }

variable "rg_name" { type=string }
variable "location" { type=string, default="eastus" }
variable "cluster_name" { type=string }
variable "db_name" { type=string }

resource "azurerm_kusto_cluster" "adx" {
  name                = var.cluster_name
  location            = var.location
  resource_group_name = var.rg_name
  sku { name = "Dev(No SLA)_Standard_E2a_v4" capacity = 1 }
}

resource "azurerm_kusto_database" "db" {
  name                = var.db_name
  resource_group_name = var.rg_name
  location            = var.location
  cluster_name        = azurerm_kusto_cluster.adx.name
  soft_delete_period  = "P365D"
  hot_cache_period    = "P14D"
}

resource "azurerm_kusto_script" "tables" {
  name = "evidence-schema"
  resource_group_name = var.rg_name
  location = var.location
  cluster_name = azurerm_kusto_cluster.adx.name
  database_name = azurerm_kusto_database.db.name
  script_content = <<KQL
.create-merge table Evidence (kind:string, status:string, timestamp:datetime, source:string, path:string, details:dynamic)
.create-merge table Evidence ingestion json mapping 'evidenceMapping' '[{"column":"kind","path":"$.kind"},{"column":"status","path":"$.status"},{"column":"timestamp","path":"$.timestamp"},{"column":"source","path":"$.source"},{"column":"path","path":"$.path"},{"column":"details","path":"$.details"}]'
KQL
  continue_on_errors_enabled = false
}
