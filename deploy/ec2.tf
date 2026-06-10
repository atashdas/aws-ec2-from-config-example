locals {
  ec2_defaults = try(local.config_data.landscape.instances.defaults, {})
  instances = merge(flatten([
    for svrName, svrConfig in try(local.config_data.landscape.instances.servers, {}) : {
      (svrName) = {
        name                      = svrName
        ami_id                    = lookup(svrConfig, "ami_id", try(local.ec2_defaults.ami_id, ""))
        type                      = lookup(svrConfig, "type", try(local.ec2_defaults.os_type, ""))
        key_name                  = lookup(svrConfig, "key_name", try(local.ec2_defaults.key_name, null))
        instance_type             = lookup(svrConfig, "instance_type", try(local.ec2_defaults.instance_type, null))
        instance_profile          = lookup(svrConfig, "instance_profile", try(local.ec2_defaults.instance_profile, null))
        subnet_id                 = lookup(svrConfig, "subnet_id", try(local.ec2_defaults.subnet_id, null))
        private_ip                = lookup(svrConfig, "private_ip", "")
        secondary_ip_list         = lookup(svrConfig, "secondary_ip_list", [])
        security_group_list       = concat(lookup(svrConfig, "security_group_list", []), try(local.ec2_defaults.security_group_list, []))
        is_system_status_check    = lookup(svrConfig, "is_system_status_check", try(local.ec2_defaults.is_system_status_check, false))
        is_instance_status_check  = lookup(svrConfig, "is_instance_status_check", try(local.ec2_defaults.is_instance_status_check, false))
        ok_actions                = lookup(svrConfig, "ok_actions", try(local.ec2_defaults.ok_actions, []))
        alarm_actions             = lookup(svrConfig, "alarm_actions", try(local.ec2_defaults.alarm_actions, []))
        insufficient_data_actions = lookup(svrConfig, "insufficient_data_actions", try(local.ec2_defaults.insufficient_data_actions, []))
        kms_key_id                = lookup(svrConfig, "kms_key_id", try(local.ec2_defaults.kms_key_id, null))
        tags                      = merge(lookup(svrConfig, "tags", {}), try(local.ec2_defaults.tags, {}), local.g_tags)
        disks = merge(flatten([
          for diskKey, diskConfig in lookup(svrConfig, "disks", {}) : {
            (diskKey) = {
              name        = lookup(diskConfig, "name", null)
              device_name = lookup(diskConfig, "device_name", null)
              iops        = lookup(diskConfig, "iops", try(local.ec2_defaults.disk.iops, "3000"))
              throughput  = lookup(diskConfig, "throughput", try(local.ec2_defaults.disk.throughput, "125"))
              volume_size = lookup(diskConfig, "volume_size", try(local.ec2_defaults.disk.volume_size, null))
              volume_type = lookup(diskConfig, "volume_type", try(local.ec2_defaults.disk.volume_type, "gp3"))
              tags        = merge(lookup(diskConfig, "tags", {}), lookup(svrConfig, "tags", {}), try(local.ec2_defaults.tags, {}), local.g_tags)
            }
          }
        ])...)
      }
    }
  ])...)
}

module "ec2" {
  source         = "../modules/my-ec2-instance"
  ec2_parameters = local.instances
}
