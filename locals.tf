locals {
  name         = format("%s-%s-%s", var.prefix, var.environment, var.app)
  cluster_name = var.eks_cluster
  tags = merge(
    var.tags,
    {
      environment = var.environment
      app         = var.app
      iac         = "terraform"
    }
  )
}
