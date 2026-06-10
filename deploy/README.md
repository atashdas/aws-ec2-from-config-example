# deploy

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
| ---- | ------ | ------- |
| <a name="module_ec2"></a> [ec2](#module\_ec2) | ../modules/my-ec2-instance | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_config_file"></a> [config\_file](#input\_config\_file) | The S3 key for the config file. | `string` | `"desired_config.json"` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_ec2_details"></a> [ec2\_details](#output\_ec2\_details) | Details of the deployed instances |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
