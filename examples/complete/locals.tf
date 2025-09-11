locals {
  tags = {
    environment = var.environment
    app         = var.application
    iac         = "terraform"
  }
}
