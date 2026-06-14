terraform {
  required_version = ">= 1.9.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.110.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "tfstateabdalhakim123"
    container_name       = "tfstate"
    key                  = "proj2.terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}