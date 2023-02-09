resource "azurerm_resource_group" "demo" {
  name     = "example-resources"
  location = "West Europe"
}


resource "azurerm_storage_account" "StorageAccountDemo" {
  name                     = "satestant000012"
  resource_group_name      = azurerm_resource_group.demo.name
  location                 = azurerm_resource_group.demo.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = {
    video = "azure"
    channel = "hari11"
  }
}

data "azurerm_key_vault" "example" {
  name                = "snowflake-terraform"
  resource_group_name = "snowflake"
}

data "azurerm_key_vault_secret" "test" {
  name      = "tf-snowflake-password"
  key_vault_id = data.azurerm_key_vault.example.id

  # vault_uri is deprecated in latest azurerm, use key_vault_id instead.
   #vault_uri = "https://cicdtestkvraj.vault.azure.net/"
}

data "azurerm_key_vault_secret" "test1" {
  name      = "tf-snowflake-account"
  key_vault_id = data.azurerm_key_vault.example.id

  # vault_uri is deprecated in latest azurerm, use key_vault_id instead.
   #vault_uri = "https://cicdtestkvraj.vault.azure.net/"
}

data "azurerm_key_vault_secret" "test2" {
  name = "tf-snowflake-username"
  key_vault_id = data.azurerm_key_vault.example.id
}

output "snowflake_password" {
  value = data.azurerm_key_vault_secret.test.value
  
  sensitive = true
}

output "snowflake_account" {
  value = data.azurerm_key_vault_secret.test1.value
  sensitive = true
}

output "snowflake_username" {
  value = data.azurerm_key_vault_secret.test2.value
  sensitive = true
}

/*output "snowflake_account" {
  
}*/

resource "azurerm_resource_group" "perview-trile" {
  name     = "purview"
  location = "East US"
}

resource "azurerm_resource_group" "perview-trile1" {
  name     = "purview-trile11"
  location = "West Europe"
}

/*resource "azurerm_purview_account" "example" {
  name                = "purview-trile-01"
  resource_group_name = azurerm_resource_group.perview-trile.name
  location            = azurerm_resource_group.perview-trile.location

  identity {
    type = "SystemAssigned"
  }
}*/

resource "azurerm_purview_account" "example1" {
  name                = "purview-trile001"
  resource_group_name = azurerm_resource_group.perview-trile1.name
  location            = azurerm_resource_group.perview-trile1.location

  identity {
    type = "SystemAssigned"
  }
}

/*resource "azurerm_purview_account" "example01" {
  name                = "purview-trile101"
  resource_group_name = azurerm_resource_group.perview-trile.name
  location            = azurerm_resource_group.perview-trile.location
  managed_resource_group_name = "purview_managed_resource"
  identity {
    type = "SystemAssigned"
  }
}*/

resource "azapi_resource" "symbolicname" {
  type = "Microsoft.Purview/accounts@2021-07-01"
  name = "harishperview"
  location = "West Europe"
  parent_id = azurerm_resource_group.perview-trile1.id
  
  identity {
    type = "SystemAssigned"
    #identity_ids = ["SystemAssigned"]
  }
  body = jsonencode({
    properties = {
      cloudConnectors = {}
      managedResourceGroupName = "purview-trile101"
      publicNetworkAccess = "Enabled"
    }
  })
}

provider "snowflake" {
 username = data.azurerm_key_vault_secret.test2.value
 account = data.azurerm_key_vault_secret.test1.value
 #role = "accountadmin"
 password = data.azurerm_key_vault_secret.test.value
}

module "snowflake_WAREHOUSE_WH0022" {                                                             # NAME OF THE MODULE
  source            = "./WAREHOUSE_MODULE"                                                       # THIS IS THE SOURCE OF THE MODULE
  warehouse_name    = "snowflake_WAREHOUSE_WH0022"                                                # THIS IS THE NAME OF THE WAREHOUSE 
  warehouse_size    = "SMALL"                                                                    # THIS IS THE REQUIRED SIZE OF THE WAREHOUSE
  roles = {
    "OWNERSHIP" = ["SYSADMIN"],                                                                  # HERE WE WILL GIVE THE WAREHOUSE_GRANT AND PREVILEGE FOR PERTICULAR ROLES
    "USAGE" = ["SYSADMIN"]
  }
  with_grant_option = false
}
