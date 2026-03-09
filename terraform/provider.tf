terraform { 
    required_providers {
        azurerm = {
            source = "hashcorp/azurerm"
            version = "~> 3.0"
            }
        }
    }
    provider "azurerm" {
        features{}
        subscription_ = var.subscription_id
        }