# aws-ec2-from-config-example
Launches a fleet of AWS EC2 instances per configuration in YAML or JSON configuration file. This implementation demonstrates a **configuration-first** approach to EC2 provisioning where a YAML or JSON configuration defines `what` needs to be deployed, and a generic Terraform module decides `how` they are deployed.
