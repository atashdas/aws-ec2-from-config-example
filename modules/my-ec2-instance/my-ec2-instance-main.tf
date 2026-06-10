locals {
  linux_instances   = { for k, v in var.ec2_parameters : k => v if v.type == "linux" }
  windows_instances = { for k, v in var.ec2_parameters : k => v if v.type == "windows" }

  sys_stat_chk_instances = { for k, v in var.ec2_parameters : k => v if v.is_system_status_check == true }
  ins_stat_chk_instances = { for k, v in var.ec2_parameters : k => v if v.is_instance_status_check == true }
}


data "aws_region" "current" {}

resource "aws_instance" "this" {
  for_each = var.ec2_parameters

  ami                     = each.value.ami_id
  instance_type           = each.value.instance_type
  iam_instance_profile    = each.value.instance_profile
  key_name                = each.value.key_name
  private_ip              = each.value.private_ip != "" ? each.value.private_ip : null
  secondary_private_ips   = length(each.value.secondary_ip_list) > 0 ? each.value.secondary_ip_list : null
  security_groups         = each.value.security_group_list
  subnet_id               = each.value.subnet_id
  monitoring              = true
  ebs_optimized           = true
  disable_api_termination = true

  user_data = (each.value.type == "windows"
    ? data.template_file.windows_userdata[each.key].rendered
  : data.template_file.linux_userdata[each.key].rendered)

  dynamic "ebs_block_device" {
    for_each = each.value.disks
    content {
      delete_on_termination = true
      encrypted             = true
      device_name           = ebs_block_device.value.device_name
      iops                  = lookup(ebs_block_device.value, "iops", "3000")
      kms_key_id            = each.value.kms_key_id
      throughput            = lookup(ebs_block_device.value, "throughput", "125")
      volume_size           = ebs_block_device.value.volume_size
      volume_type           = lookup(ebs_block_device.value, "volume_type", "gp3")
      tags                  = merge({ Name = "${each.value.name} ${ebs_block_device.value.name}", Type = "Storage" }, each.value.tags)
    }
  }

  metadata_options {
    http_tokens = "required"
  }
  root_block_device {
    encrypted = true
  }

  tags = merge({ Name = each.value.name, Type = "Compute" }, each.value.tags)
}

# Alarm if a system status check ever fails for at least five minutes straight.
resource "aws_cloudwatch_metric_alarm" "system_status_check" {
  for_each = local.sys_stat_chk_instances

  alarm_actions       = flatten([each.value.alarm_actions, "arn:aws:automate:${data.aws_region.current.region}:ec2:recover"])
  alarm_description   = "Monitor EC2 system status check"
  alarm_name          = "ec2_system_status_check_${each.key}_${aws_instance.this[each.key].id}"
  comparison_operator = "GreaterThanThreshold"
  dimensions = {
    InstanceId = aws_instance.this[each.key].id
  }
  evaluation_periods        = 5
  insufficient_data_actions = each.value.insufficient_data_actions
  metric_name               = "StatusCheckFailed_System"
  namespace                 = "AWS/EC2"
  ok_actions                = each.value.ok_actions
  period                    = 60
  statistic                 = "Maximum"
  threshold                 = 5
}

# Alarm if an instance status check ever fails for at least five minutes straight.
resource "aws_cloudwatch_metric_alarm" "instance_status_check" {
  for_each = local.ins_stat_chk_instances

  alarm_actions       = flatten([each.value.alarm_actions, "arn:aws:automate:${data.aws_region.current.region}:ec2:reboot"])
  alarm_description   = "Monitor EC2 instance status check"
  alarm_name          = "ec2_instance_status_check_${each.key}_${aws_instance.this[each.key].id}"
  comparison_operator = "GreaterThanThreshold"
  dimensions = {
    InstanceId = aws_instance.this[each.key].id
  }
  evaluation_periods        = 5
  insufficient_data_actions = each.value.insufficient_data_actions
  metric_name               = "StatusCheckFailed_Instance"
  namespace                 = "AWS/EC2"
  ok_actions                = each.value.ok_actions
  period                    = 60
  statistic                 = "Maximum"
  threshold                 = 5
}

data "aws_network_interface" "this" {
  for_each = var.ec2_parameters
  id       = aws_instance.this[each.key].primary_network_interface_id
}

# Bootstrapping PowerShell Script
data "template_file" "windows_userdata" {
  for_each = local.windows_instances
  template = <<EOF
<powershell>
# Rename Machine
Rename-Computer -NewName "${each.value.name}" -Force;
# Restart machine
shutdown -r -t 10;
</powershell>
EOF
}

# Bootstrapping Shell Script
data "template_file" "linux_userdata" {
  for_each = local.linux_instances
  template = <<EOF
#!/bin/bash
hostnamectl set-hostname "${each.value.name}"
EOF
}
