# Generic microservice

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

# Creating a Release Tag for the Terraform Module

To create a versioned release and push it to GitHub:

```bash
# 1. Make sure all changes are committed
git add .
git commit -m "feat: initial implementation of module"

# 2. Create a version tag (e.g., v1.0.0)
git tag -a v1.0.0 -m "Initial stable release"

# 3. Push the tag to GitHub
git push origin v1.0.0

# 4. Create a GitHub release for the tag (optional, via CLI)
gh release create v1.0.0 \
  --title "v1.0.0" \
  --notes "Initial stable release of the Terraform module"
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
| <a name="module_eks_pod_identity"></a> [eks\_pod\_identity](#module\_eks\_pod\_identity) | terraform-aws-modules/eks-pod-identity/aws | 2.0.0 |
| <a name="module_kms"></a> [kms](#module\_kms) | terraform-aws-modules/kms/aws | 4.1.0 |
| <a name="module_sqs"></a> [sqs](#module\_sqs) | terraform-aws-modules/sqs/aws | 5.0.0 |
| <a name="module_ssm"></a> [ssm](#module\_ssm) | terraform-aws-modules/ssm-parameter/aws | 1.1.2 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_metric_alarm.sqs_age_of_messages](https://registry.terraform.io/providers/hashicorp/aws/6.6.0/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.sqs_number_of_messages](https://registry.terraform.io/providers/hashicorp/aws/6.6.0/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/6.6.0/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/6.6.0/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application"></a> [application](#input\_application) | The name of the application | `string` | n/a | yes |
| <a name="input_eks_cluster"></a> [eks\_cluster](#input\_eks\_cluster) | The name of the EKS cluster | `string` | `""` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment of the application | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | The namespace of the application | `string` | n/a | yes |
| <a name="input_policy"></a> [policy](#input\_policy) | The inline policy document | `string` | `""` | no |
| <a name="input_sqs_queues"></a> [sqs\_queues](#input\_sqs\_queues) | The SQS queues to create | <pre>map(object({<br/>    name                                  = string<br/>    use_name_prefix                       = optional(bool)<br/>    is_fifo                               = optional(bool, false)<br/>    sqs_managed_sse_enabled               = optional(bool, true)<br/>    enable_dead_letter_queue              = optional(bool, false)<br/>    max_receive_count                     = optional(number)<br/>    content_based_deduplication           = optional(bool, null)<br/>    deduplication_scope                   = optional(bool, null)<br/>    delay_seconds                         = optional(number)<br/>    fifo_throughput_limit                 = optional(string)<br/>    max_message_size                      = optional(number)<br/>    message_retention_seconds             = optional(number)<br/>    receive_wait_time_seconds             = optional(number)<br/>    redrive_allow_policy                  = optional(any, {})<br/>    redrive_policy                        = optional(any)<br/>    visibility_timeout_seconds            = optional(number)<br/>    source_queue_policy_documents         = optional(list(string))<br/>    override_queue_policy_documents       = optional(list(string))<br/>    create_queue_policy                   = optional(bool, true)<br/>    queue_policy_statements               = optional(any)<br/>    dlq_content_based_deduplication       = optional(bool, null)<br/>    dlq_deduplication_scope               = optional(string)<br/>    dlq_delay_seconds                     = optional(number)<br/>    dlq_message_retention_seconds         = optional(number)<br/>    dlq_name                              = optional(string)<br/>    dlq_receive_wait_time_seconds         = optional(number)<br/>    create_dlq_redrive_allow_policy       = optional(bool, true)<br/>    dlq_redrive_allow_policy              = optional(any, {})<br/>    dlq_sqs_managed_sse_enabled           = optional(bool, true)<br/>    dlq_visibility_timeout_seconds        = optional(number)<br/>    dlq_tags                              = optional(map(string))<br/>    create_dlq_queue_policy               = optional(bool, true)<br/>    source_dlq_queue_policy_documents     = optional(list(string))<br/>    override_dlq_queue_policy_documents   = optional(list(string))<br/>    dlq_queue_policy_statements           = optional(any)<br/>    create_cloudwatch_alarms              = optional(bool, false)<br/>    kms_data_key_reuse_period_seconds     = optional(number, 86400)<br/>    dlq_kms_data_key_reuse_period_seconds = optional(number, 86400)<br/>  }))</pre> | `{}` | no |
| <a name="input_ssm_secrets"></a> [ssm\_secrets](#input\_ssm\_secrets) | The SSM secrets to create | <pre>map(object({<br/>    name                 = string<br/>    tier                 = optional(string)<br/>    type                 = optional(string)<br/>    value                = string<br/>    ignore_value_changes = bool<br/>  }))</pre> | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | The tags to apply to all resources | `map(string)` | `{}` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
