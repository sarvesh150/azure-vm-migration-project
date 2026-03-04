# Resource Group
resource "azurerm_resource_group" "main" {
name = "rg-vm-migration-${var.environment}"
location = var.location
tags = {
  environment = var.environment
  project = "VM-migration"
}
}

#Virtual Network
resource "azurerm_virtual_network" "main" {
name = "vnet-migration"
location = azurerm_resource_group.main.location
resource_group_name = azurerm_resource_group.main.name
address_space = ["10.0.0.0/16"]
}

#Web Tier Subnet
resource "azurerm_subnet" "web" {
name = "subnet-web"
virtual_network_name = azurerm_virtual_network.main.name
resource_group_name = azurerm_resource_group.main.name
address_prefixes = ["10.0.1.0/24"]
}

#App Tier Subnet
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
resource_group_name = azurerm_resource_group.main.name
address_prefixes = ["10.0.3.0/24"]

delegation {
  name = "managedInstanceDelegation"
  service_delegation {
    name = "Microsoft.Sql/managedInstances"
    actions = [
      "Microsoft.Network/virtualNetworks/subnets/join/action",
      "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
      "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"
    ]
  }
}
}

#Network Security Group for web Tier
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
  source_address_prefix = "*"
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

#create twi NIC's for Web Tier VM's

resource "azurerm_network_interface" "web" {
count = 2
name = "nic-web-${count.index + 1}"
location = azurerm_resource_group.main.location
resource_group_name = azurerm_resource_group.main.name
ip_configuration {
    name = "testConfiguration"
    subnet_id = azurerm_subnet.web.id
    private_ip_address_allocation = "Dynamic"
    }
}

resource "azurerm_public_ip" "lb" {
    name = "pip-lb"
    location = azurerm_resource_group.main.location
    resource_group_name = azurerm_resource_group.main.name
    allocation_method = "Static"
    sku = "Standard"
}

resource "azurerm_lb" "main"{
    name = "lb-main"
    location = azurerm_resource_group.main.location
    resource_group_name = azurerm_resource_group.main.name
    sku = "Standard"
    frontend_ip_configuration{
       name = "PublicIPAddress"
       public_ip_address_id=azurerm_public_ip.lb.id
       }
}

resource "azurerm_lb_backend_address_pool" "main" {
    loadbalancer_id = azurerm_lb.main.id
    name = "BackEndAddressPool"
}

resource "azurerm_lb_probe" "main" {
  loadbalancer_id = azurerm_lb.main.id
  name            = "http-probe"
  protocol        = "Http"
  port            = 80
  request_path    = "/"
}

resource "azurerm_lb_rule" "main" {
    loadbalancer_id = azurerm_lb.main.id
    name = "LBRule"
    protocol = "Tcp"
    frontend_port = 80
    backend_port = 80
    frontend_ip_configuration_name = "PublicIPAddress"
    backend_address_pool_ids = [azurerm_lb_backend_address_pool.main.id]
    probe_id = azurerm_lb_probe.main.id
}

