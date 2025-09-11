# Generic microservice example

Configuration in this directory creates generic microservice resources - EKS Pod Identities, SSM parameters, SQS queues with KMS keys and CLoudWatch alarms.

## Usage

To run this example execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

To destroy this example execute:

```bash
$ terraform destroy
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | 1.12.2 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 6.6.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.6.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_microservice"></a> [microservice](#module\_microservice) | ../ | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/6.6.0/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application"></a> [application](#input\_application) | The name of the application | `string` | `"api"` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The AWS region to deploy to | `string` | `"eu-central-1"` | no |
| <a name="input_eks_cluster"></a> [eks\_cluster](#input\_eks\_cluster) | The name of the EKS cluster | `string` | `"eks-cluster"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment of the application | `string` | `"sandbox"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | The namespace of the application | `string` | `"apps"` | no |
| <a name="input_sqs_queues"></a> [sqs\_queues](#input\_sqs\_queues) | The SQS queues to create | <pre>map(object({<br/>    name                                  = string<br/>    use_name_prefix                       = optional(bool)<br/>    is_fifo                               = optional(bool, false)<br/>    sqs_managed_sse_enabled               = optional(bool, true)<br/>    enable_dead_letter_queue              = optional(bool, false)<br/>    max_receive_count                     = optional(number)<br/>    content_based_deduplication           = optional(bool, null)<br/>    deduplication_scope                   = optional(bool, null)<br/>    delay_seconds                         = optional(number)<br/>    fifo_throughput_limit                 = optional(string)<br/>    max_message_size                      = optional(number)<br/>    message_retention_seconds             = optional(number)<br/>    receive_wait_time_seconds             = optional(number)<br/>    redrive_allow_policy                  = optional(any, {})<br/>    redrive_policy                        = optional(any)<br/>    visibility_timeout_seconds            = optional(number)<br/>    source_queue_policy_documents         = optional(list(string))<br/>    override_queue_policy_documents       = optional(list(string))<br/>    create_queue_policy                   = optional(bool, true)<br/>    queue_policy_statements               = optional(any)<br/>    dlq_content_based_deduplication       = optional(bool, null)<br/>    dlq_deduplication_scope               = optional(string)<br/>    dlq_delay_seconds                     = optional(number)<br/>    dlq_message_retention_seconds         = optional(number)<br/>    dlq_name                              = optional(string)<br/>    dlq_receive_wait_time_seconds         = optional(number)<br/>    create_dlq_redrive_allow_policy       = optional(bool, true)<br/>    dlq_redrive_allow_policy              = optional(any, {})<br/>    dlq_sqs_managed_sse_enabled           = optional(bool, true)<br/>    dlq_visibility_timeout_seconds        = optional(number)<br/>    dlq_tags                              = optional(map(string))<br/>    create_dlq_queue_policy               = optional(bool, true)<br/>    source_dlq_queue_policy_documents     = optional(list(string))<br/>    override_dlq_queue_policy_documents   = optional(list(string))<br/>    dlq_queue_policy_statements           = optional(any)<br/>    create_cloudwatch_alarms              = optional(bool, false)<br/>    kms_data_key_reuse_period_seconds     = optional(number, 86400)<br/>    dlq_kms_data_key_reuse_period_seconds = optional(number, 86400)<br/>  }))</pre> | <pre>{<br/>  "queue-with-alarm-and-dlq": {<br/>    "create_cloudwatch_alarms": true,<br/>    "enable_dead_letter_queue": true,<br/>    "max_receive_count": 1,<br/>    "name": "queue-with-alarm-and-dlq",<br/>    "receive_wait_time_seconds": 10<br/>  },<br/>  "queue-without-alarm-and-dlq": {<br/>    "create_cloudwatch_alarms": false,<br/>    "enable_dead_letter_queue": false,<br/>    "max_receive_count": 1,<br/>    "name": "queue-without-alarm-and-dlq",<br/>    "receive_wait_time_seconds": 10<br/>  }<br/>}</pre> | no |
| <a name="input_ssm_parameters"></a> [ssm\_parameters](#input\_ssm\_parameters) | The SSM secrets to create | <pre>map(object({<br/>    name                 = string<br/>    tier                 = optional(string)<br/>    type                 = optional(string)<br/>    value                = string<br/>    ignore_value_changes = bool<br/>  }))</pre> | <pre>{<br/>  "secure-secret": {<br/>    "ignore_value_changes": true,<br/>    "name": "secure-secret",<br/>    "tier": "Standard",<br/>    "type": "SecureString",<br/>    "value": "{}"<br/>  },<br/>  "string-secret": {<br/>    "ignore_value_changes": true,<br/>    "name": "string-secret",<br/>    "tier": "Standard",<br/>    "type": "String",<br/>    "value": "{}"<br/>  }<br/>}</pre> | no |
| <a name="input_tags"></a> [tags](#input\_tags) | The tags to apply to all resources | `map(string)` | `{}` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
