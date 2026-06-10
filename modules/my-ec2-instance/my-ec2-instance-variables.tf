variable "ec2_parameters" {
  description = "EC2 parameers for instances to be created"
  type = map(object({
    ami_id                    = string
    type                      = string
    name                      = string
    key_name                  = string
    instance_type             = string
    instance_profile          = string
    subnet_id                 = string
    private_ip                = string
    secondary_ip_list         = list(string)
    security_group_list       = list(string)
    is_system_status_check    = bool
    is_instance_status_check  = bool
    ok_actions                = list(string)
    alarm_actions             = list(string)
    insufficient_data_actions = list(string)
    kms_key_id                = string
    disks                     = any
    tags                      = map(string)
  }))
}
