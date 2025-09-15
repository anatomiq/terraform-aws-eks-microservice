module "microservice" {
  source = "../../"

  environment    = var.environment
  application    = var.application
  namespace      = var.namespace
  ssm_parameters = var.ssm_parameters
  sqs_queues     = var.sqs_queues
  cluster_name   = var.cluster_name
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : ["ssm:*"],
        "Resource" : ["arn:aws:ssm:${var.aws_region}:${data.aws_caller_identity.current.account_id}:parameter/${var.environment}/app/${var.application}/*"]
      },
      {
        "Sid" : "SenderReceiver",
        "Effect" : "Allow",
        "Action" : [
          "sqs:ChangeMessageVisibility",
          "sqs:SendMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes",
          "sqs:GetQueueUrl",
          "sqs:ReceiveMessage"
        ],
        "Resource" : "arn:aws:sqs:${var.aws_region}:${data.aws_caller_identity.current.account_id}:*"
      }
    ]
  })
  tags = var.tags
}
