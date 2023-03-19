resource "azurerm_kubernetes_cluster" "aks_jlgf" {
  name                = "jlgf-aks1"
  location            = azurerm_resource_group.jlgf.location
  resource_group_name = azurerm_resource_group.jlgf.name
  dns_prefix          = "jlgfaks1"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "PRO"
  }
}
