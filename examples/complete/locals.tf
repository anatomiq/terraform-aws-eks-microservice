locals {
  tags = {
    environment = var.environment
    app         = var.app
    iac         = "terraform"
  }
}
