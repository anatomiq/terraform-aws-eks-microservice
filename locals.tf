locals {
  name = join("-", compact([
    var.prefix,
    var.environment,
    var.application
  ]))
  tags = merge(
    var.tags,
    {
      environment = var.environment
      app         = var.application
      iac         = "terraform"
    }
  )
}
