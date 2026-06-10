output "ec2_details" {
  description = "Details of the deployed instances"
  value       = module.ec2.instances
}
