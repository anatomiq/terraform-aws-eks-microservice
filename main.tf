module "eks_pod_identity" {
  source  = "terraform-aws-modules/eks-pod-identity/aws"
  version = "2.0.0"

  name            = local.name
  use_name_prefix = false
  description     = "IAM role for EKS application - ${var.app}"
  association_defaults = {
    namespace       = var.namespace
    service_account = var.app
  }
  associations = {
    "${local.cluster_name}" = {
      cluster_name = local.cluster_name
    }
  }
  attach_custom_policy      = true
  custom_policy_description = "IAM role for EKS application - ${var.app}"
  source_policy_documents   = [var.policy]

  tags = local.tags
}

module "ssm" {
  source  = "terraform-aws-modules/ssm-parameter/aws"
  version = "1.1.2"

  ignore_value_changes = try(each.value.ignore_value_changes, true)

  for_each = var.ssm_secrets

  name  = format("/%s/app/%s/%s", var.environment, var.app, each.value.name)
  tier  = try(each.value.tier, "Standard")
  type  = try(each.value.type, "SecureString")
  value = each.value.value

  tags = local.tags
}

module "kms" {
  source  = "terraform-aws-modules/kms/aws"
  version = "4.1.0"

  for_each = var.sqs_queues

  aliases = [
    each.value.name
  ]
  aliases_use_name_prefix  = true
  description              = "KMS key for ${each.value.name}"
  key_usage                = "ENCRYPT_DECRYPT"
  customer_master_key_spec = "SYMMETRIC_DEFAULT"
  key_administrators = [
    module.eks_pod_identity.iam_role_arn
  ]
  key_statements = [
    {
      sid = "ApplicationAccess"
      actions = [
        "kms:Encrypt",
        "kms:Decrypt",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*"
      ]
      resources = ["*"]
      principals = [
        {
          type = "AWS"
          identifiers = [
            module.eks_pod_identity.iam_role_arn
          ]
        }
      ]
    }
  ]
  enable_key_rotation = true

  tags = local.tags
}

module "sqs" {
  source  = "terraform-aws-modules/sqs/aws"
  version = "5.0.0"

  for_each = var.sqs_queues

  name                                = each.value.name
  fifo_queue                          = try(each.value.is_fifo, false)
  sqs_managed_sse_enabled             = try(each.value.sqs_managed_sse_enabled, true)
  create_dlq                          = try(each.value.enable_dead_letter_queue, false)
  dlq_sqs_managed_sse_enabled         = try(each.value.enable_dead_letter_queue, true)
  dlq_content_based_deduplication     = try(each.value.dlq_content_based_deduplication, null)
  dlq_deduplication_scope             = try(each.value.dlq_deduplication_scope, null)
  dlq_delay_seconds                   = try(each.value.dlq_delay_seconds, null)
  dlq_message_retention_seconds       = try(each.value.dlq_message_retention_seconds, null)
  dlq_name                            = try(each.value.dlq_name, null)
  dlq_receive_wait_time_seconds       = try(each.value.dlq_receive_wait_time_seconds, null)
  create_dlq_redrive_allow_policy     = try(each.value.create_dlq_redrive_allow_policy, true)
  dlq_redrive_allow_policy            = try(each.value.dlq_redrive_allow_policy, {})
  dlq_visibility_timeout_seconds      = try(each.value.dlq_receive_wait_time_seconds, null)
  create_dlq_queue_policy             = try(each.value.create_dlq_queue_policy, true)
  source_dlq_queue_policy_documents   = try(each.value.source_dlq_queue_policy_documents, [])
  override_dlq_queue_policy_documents = try(each.value.override_dlq_queue_policy_documents, [])
  dlq_queue_policy_statements = merge({
    account = {
      sid = "__owner_statement"
      actions = [
        "sqs:*"
      ]
      principals = [
        {
          type        = "AWS"
          identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
        }
      ]
    }
    app = {
      sid = "__app_statement"
      actions = [
        "sqs:SendMessage",
        "sqs:ReceiveMessage",
        "sqs:DeleteMessage",
        "sqs:GetQueueAttributes",
        "sqs:GetQueueUrl",
        "sqs:ChangeMessageVisibility"
      ]
      principals = [
        {
          type        = "AWS"
          identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${local.name}"]
        }
      ]
    }
  }, each.value.dlq_queue_policy_statements, {})
  redrive_policy = (try(each.value.enable_dead_letter_queue, false) ? {
    maxReceiveCount = try(each.value.max_receive_count, 5)
  } : {})
  redrive_allow_policy            = try(each.value.redrive_allow_policy, {})
  content_based_deduplication     = try(each.value.content_based_deduplication, null)
  deduplication_scope             = try(each.value.deduplication_scope, null)
  delay_seconds                   = try(each.value.delay_seconds, null)
  fifo_throughput_limit           = try(each.value.fifo_throughput_limit, null)
  max_message_size                = try(each.value.max_message_size, null)
  message_retention_seconds       = try(each.value.message_retention_seconds, null)
  receive_wait_time_seconds       = try(each.value.receive_wait_time_seconds, null)
  visibility_timeout_seconds      = try(each.value.visibility_timeout_seconds, null)
  source_queue_policy_documents   = try(each.value.source_queue_policy_documents, [])
  override_queue_policy_documents = try(each.value.override_queue_policy_documents, [])
  create_queue_policy             = try(each.value.create_queue_policy, true)
  queue_policy_statements = merge({
    app = {
      sid = "__app_statement"
      actions = [
        "sqs:SendMessage",
        "sqs:ReceiveMessage",
        "sqs:DeleteMessage",
        "sqs:GetQueueAttributes",
        "sqs:GetQueueUrl",
        "sqs:ChangeMessageVisibility"
      ]
      principals = [
        {
          type        = "AWS"
          identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${local.name}"]
        }
      ]
    }
  }, each.value.queue_policy_statements, {})
  kms_master_key_id                     = module.kms[each.key].key_id
  kms_data_key_reuse_period_seconds     = try(each.value.kms_data_key_reuse_period_seconds, 86400)
  dlq_kms_master_key_id                 = module.kms[each.key].key_id
  dlq_kms_data_key_reuse_period_seconds = try(each.value.kms_data_key_reuse_period_seconds, 86400)
  dlq_tags                              = local.tags
  tags                                  = local.tags
}

resource "aws_cloudwatch_metric_alarm" "sqs_number_of_messages" {
  for_each = {
    for k, v in var.sqs_queues : k => v
    if try(v.create_cloudwatch_alarms, false) == true
  }

  alarm_name          = format("SQS_NumberOfMessagesSent-%s", each.value.name)
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  datapoints_to_alarm = 1
  metric_name         = "NumberOfMessagesSent"
  namespace           = "AWS/SQS"
  period              = 120
  statistic           = "Average"
  threshold           = 100
  alarm_description   = format("High number of visible messages in SQS queue: %s", each.value.name)
  alarm_actions = [
    "arn:aws:sns:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:klp-${var.environment}-alerts-chatbot"
  ]

  dimensions = {
    "QueueName" = each.value.name
  }

  tags = local.tags
}

resource "aws_cloudwatch_metric_alarm" "sqs_age_of_messages" {
  for_each = {
    for k, v in var.sqs_queues : k => v
    if try(v.create_cloudwatch_alarms, false) == true
  }

  alarm_name          = format("SQS_ApproximateAgeOfOldestMessage-%s", each.value.name)
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  datapoints_to_alarm = 1
  metric_name         = "ApproximateAgeOfOldestMessage"
  namespace           = "AWS/SQS"
  period              = 300
  statistic           = "Average"
  threshold           = 300
  alarm_description   = format("Oldest message in the SQS queue %s is older than 5 minutes", each.value.name)
  alarm_actions = [
    "arn:aws:sns:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:klp-${var.environment}-alerts-chatbot"
  ]

  dimensions = {
    "QueueName" = each.value.name
  }

  tags = local.tags
}
