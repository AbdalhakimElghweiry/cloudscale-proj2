resource "azurerm_resource_group" "main" {
  name     = "abdalhakim-proj2-aci-rg"
  location = var.location

  tags = {
    Project     = "Project2"
    Environment = "production"
    StudentName = var.student_name
  }
}

resource "azurerm_container_group" "main" {
  name                = "abdalhakim-v2cloudanddevopsproject"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  ip_address_type     = "Public"
  dns_name_label      = "abdalhakim-proj2-app"
  os_type             = "Linux"

  container {
    name   = "v2cloudanddevopsproject-web"
    image  = var.docker_image
    cpu    = var.container_cpu
    memory = var.container_memory

    ports {
      port     = 80
      protocol = "TCP"
    }
  }

  tags = {
    Project     = "Project2"
    Environment = "production"
    StudentName = var.student_name
  }
}