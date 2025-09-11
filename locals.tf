locals {
  name         = format("%s-%s", var.environment, var.application)
  cluster_name = var.eks_cluster
  tags = merge(
    var.tags,
    {
      environment = var.environment
      app         = var.application
      iac         = "terraform"
    }
  )
}
