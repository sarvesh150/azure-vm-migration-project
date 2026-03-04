# Adding Windows Server VM's

resource "azurerm_windows_virtual_machine" "web" {
count = 2
name = "vm-web-${count.index + 1}"
location = azurerm_resource_group.main.location
resource_group_name = azurerm_resource_group.main.name
network_interface_ids = [azurerm_network_interface.web[count.index].id]
size = "Standard_D2s_v3" #cost-efficient size
os_disk {
  caching = "ReadWrite"
  storage_account_type = "Standard_LRS"
}

source_image_reference {
  publisher = "MicrosoftWindowsServer"
  offer = "WindowsServer"
  sku = "2022-Datacenter"
  version = "latest"
}

admin_username = "migration01"
admin_password = "Resonite@1590"
}

#Adding Custom Script Extension to install IIS

resource "azurerm_virtual_machine_extension" "iis" {
  count = 2
  name = "IIS"
  virtual_machine_id = azurerm_windows_virtual_machine.web[count.index].id
  publisher = "Microsoft.Compute"
  type = "CustomScriptExtension"
  type_handler_version = "1.10"
 settings = jsonencode({
    commandToExecute = "powershell -Command Install-WindowsFeature -name Web-Server -IncludeManagementTools"
  })
}

