resource "azurerm_container_registry" "jlgf" {
  name                = "containerRegistryjlgf"
  resource_group_name = azurerm_resource_group.jlgf.name
  location            = azurerm_resource_group.jlgf.location
  sku                 = "Premium"
  admin_enabled       = false
}
