locals {
  name         = format("%s-%s-%s", var.prefix, var.environment, var.app)
  cluster_name = var.eks_cluster != "" ? var.eks_cluster : format("%s-%s-eks", var.prefix, var.environment)
  tags = merge(
    var.tags,
    {
      environment = var.environment
      app         = var.app
      iac         = "terraform"
    }
  )
}
