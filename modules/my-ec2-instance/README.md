# my-ec2-instance

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6.0 |
| <a name="requirement_template"></a> [template](#requirement\_template) | ~> 2 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 6.0 |
| <a name="provider_template"></a> [template](#provider\_template) | ~> 2 |

## Modules

No modules.

## Resources

| Name | Type |
| ---- | ---- |
| [aws_cloudwatch_metric_alarm.instance_status_check](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.system_status_check](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_instance.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_network_interface.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/network_interface) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [template_file.linux_userdata](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.windows_userdata](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_ec2_parameters"></a> [ec2\_parameters](#input\_ec2\_parameters) | EC2 parameers for instances to be created | <pre>map(object({<br/>    ami_id                    = string<br/>    type                      = string<br/>    name                      = string<br/>    key_name                  = string<br/>    instance_type             = string<br/>    instance_profile          = string<br/>    subnet_id                 = string<br/>    private_ip                = string<br/>    secondary_ip_list         = list(string)<br/>    security_group_list       = list(string)<br/>    is_system_status_check    = bool<br/>    is_instance_status_check  = bool<br/>    ok_actions                = list(string)<br/>    alarm_actions             = list(string)<br/>    insufficient_data_actions = list(string)<br/>    kms_key_id                = string<br/>    disks                     = any<br/>    tags                      = map(string)<br/>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_instances"></a> [instances](#output\_instances) | Details of the deployed instances |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
