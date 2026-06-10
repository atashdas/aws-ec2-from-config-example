output "instances" {
  description = "Details of the deployed instances"
  value = [
    for name, instance in aws_instance.this : {
      (name) = {
        id                           = instance.id
        arn                          = instance.arn
        instance_state               = instance.instance_state
        primary_network_interface_id = instance.primary_network_interface_id
        public_ip                    = instance.public_ip
        private_ips                  = data.aws_network_interface.this[name].private_ips
        instance_status_check        = try(aws_cloudwatch_metric_alarm.instance_status_check[name], null)
        system_status_check          = try(aws_cloudwatch_metric_alarm.system_status_check[name], null)
      }
    }
  ]
}
