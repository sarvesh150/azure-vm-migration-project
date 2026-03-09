# Resource Group
resource "azurerm_resource_group" "min" {
    name = "rg-vm-migration-$(Var.environment}"
    location = var.location
    tags = {
        Environment = var.environment
        project = "VM-Migration"
        }
}

# Virtual Network
resource "azurerm_virtual_network" "main" {
    name = "vnet-migration"
    location = azurerm_resource_group.main.location
    resource_group_name = azurerm_resource_group.main.name
    address_space = ["10.0.0.0/16"]
    }

# Web Tier Subnet
resource "azurerm_subnet" "web" {
    name = "subnet-web"
    virtual_network_name = azurerm_virtual_network.main.name
    resource_group_name = azurerm_resource_group.main.name
    address_prefixes = ["10.0.1.0/24"]
    }

# App Tier Subnet
resource "azurerm_subnet" "app" {
    name = "subnet-app"
    virtual_network_name = azurerm_virtual_network.main.name
    resource_group_name = azurerm_resource_group.main.name
    address_prefixes = ["10.0.2.0/24"]
    }

#Database Subnet
resource "azurerm_subnet" "database" {
    name = "subnet-database"
    virtual_network_name = azurerm_virtual_network.main.name
    virtual_group_name = azurerm_resource_group.main.name
    address_prefixes = ["10.0.3.0/24"]
    }

# NSG for Web Tier
resource "azurerm_network_security_group" "web" {
    name = "nsg-web"
    location = azurerm_resource_group.main.location
    resource_group_name = azurerm_resource_group.main.name
    security_rule {
        name = "AllowHTTP"
        priority = 100
        direction = "Inbound"
        access = "Allow"
        protocol = "Tcp"
        source_port_range = "*"
        destination_port_range = "80"
        sourcce_address_prefix = "*"
        destination_address_prefix = "*"
        }
        security_rule {
            name = "AllowHTTPS"
            priority = 110
            direction = "Inbound"
            access = "Allow"
            protocol = "Tcp"
            source_port_range = "*"
            destination_port_range = "443"
            source_address_prefix = "*"
            destination_address_prefix = "*"
            }
}
