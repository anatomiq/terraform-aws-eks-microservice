variable "aws_region" {
  description = "The AWS region to deploy to"
  type        = string
  default     = "eu-central-1"
}

variable "prefix" {
  type        = string
  description = "The prefix of the application"
  default     = "klp"
}

variable "environment" {
  type        = string
  description = "The environment of the application"
  nullable    = false
  default     = "sandbox"
}

variable "app" {
  type        = string
  description = "The name of the application"
  nullable    = false
  default     = "api"
}

variable "namespace" {
  type        = string
  description = "The namespace of the application"
  nullable    = false
  default     = "apps"
}

variable "tags" {
  type        = map(string)
  description = "The tags to apply to all resources"
  default     = {}
}

variable "ssm_secrets" {
  type = map(object({
    name                 = string
    tier                 = optional(string)
    type                 = optional(string)
    value                = string
    ignore_value_changes = bool
  }))
  description = "The SSM secrets to create"
  default = {
    secure-secret = {
      name                 = "secure-secret"
      tier                 = "Standard"
      type                 = "SecureString"
      ignore_value_changes = true
      value                = "{}"
    }
    string-secret = {
      name                 = "string-secret"
      tier                 = "Standard"
      type                 = "String"
      ignore_value_changes = true
      value                = "{}"
    }
  }
}

variable "sqs_queues" {
  type = map(object({
    name                                  = string
    use_name_prefix                       = optional(bool)
    is_fifo                               = optional(bool, false)
    sqs_managed_sse_enabled               = optional(bool, true)
    enable_dead_letter_queue              = optional(bool, false)
    max_receive_count                     = optional(number)
    content_based_deduplication           = optional(bool, null)
    deduplication_scope                   = optional(bool, null)
    delay_seconds                         = optional(number)
    fifo_throughput_limit                 = optional(string)
    max_message_size                      = optional(number)
    message_retention_seconds             = optional(number)
    receive_wait_time_seconds             = optional(number)
    redrive_allow_policy                  = optional(any, {})
    redrive_policy                        = optional(any)
    visibility_timeout_seconds            = optional(number)
    source_queue_policy_documents         = optional(list(string))
    override_queue_policy_documents       = optional(list(string))
    create_queue_policy                   = optional(bool, true)
    queue_policy_statements               = optional(any)
    dlq_content_based_deduplication       = optional(bool, null)
    dlq_deduplication_scope               = optional(string)
    dlq_delay_seconds                     = optional(number)
    dlq_message_retention_seconds         = optional(number)
    dlq_name                              = optional(string)
    dlq_receive_wait_time_seconds         = optional(number)
    create_dlq_redrive_allow_policy       = optional(bool, true)
    dlq_redrive_allow_policy              = optional(any, {})
    dlq_sqs_managed_sse_enabled           = optional(bool, true)
    dlq_visibility_timeout_seconds        = optional(number)
    dlq_tags                              = optional(map(string))
    create_dlq_queue_policy               = optional(bool, true)
    source_dlq_queue_policy_documents     = optional(list(string))
    override_dlq_queue_policy_documents   = optional(list(string))
    dlq_queue_policy_statements           = optional(any)
    create_cloudwatch_alarms              = optional(bool, false)
    kms_data_key_reuse_period_seconds     = optional(number, 86400)
    dlq_kms_data_key_reuse_period_seconds = optional(number, 86400)
  }))
  description = "The SQS queues to create"
  default = {
    queue-without-alarm-and-dlq = {
      name                      = "queue-without-alarm-and-dlq"
      create_cloudwatch_alarms  = false
      enable_dead_letter_queue  = false
      max_receive_count         = 1
      receive_wait_time_seconds = 10
    },
    queue-with-alarm-and-dlq = {
      name                      = "queue-with-alarm-and-dlq"
      create_cloudwatch_alarms  = true
      enable_dead_letter_queue  = true
      max_receive_count         = 1
      receive_wait_time_seconds = 10
    }
  }
}

variable "eks_cluster" {
  type        = string
  description = "The name of the EKS cluster"
  default     = "eks-cluster"
}
