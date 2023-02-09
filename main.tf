terraform {
  required_version = ">= 1.1.0"
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }

    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "0.39.0"
    }

    azapi = {
      source = "Azure/azapi"
      version = "1.3.0"
    }
  }
  cloud {
    organization = "terraform_snowflake"
    workspaces {
      name = "terraform_snowflake_intigration"
    }
  }
}

provider "azurerm" {
  features {}
}