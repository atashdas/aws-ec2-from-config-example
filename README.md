# aws-ec2-from-config-example
Launches a fleet of AWS EC2 instances per specifications in a YAML or JSON configuration file. This implementation demonstrates a **configuration-first** approach to EC2 provisioning where a YAML or JSON configuration defines **what** needs to be deployed, and a generic Terraform module decides **how** they are deployed.

This clean separation of concerns enable developers or business users create the specification of what EC2 instances needs to be built, and the Platform Engineering team to design and build a generic and optimised Terraform module to build these from the specification. 

This accelerates user onboarding since the users can provision EC2 instances by editing a YAML or JSON file, without needing to learn Terraform syntax or AWS resource model details. Further, if this is implemented in a GitOps pipeline, they can create or update the specification and trigger the build themselves simply with a git pull, edit, git commit and push request of the configuration file within the repository.

The repository follows the standard configuration-first structure:

```
aws-ec2-from-config-example/
├── config/                    # YAML/JSON configuration — the operator interface
├── deploy/                    # Terraform entry point
├── modules/
│   └── my-ec2-instance/       # Reusable EC2 Terraform module
├── run.sh                     # Execution wrapper
└── .pre-commit-config.yaml
```
The `modules/my-ec2-instance/` directory contains the provider-specific implementation. The `config/` directory contains the user-facing configuration. The `deploy/` layer wires the two together.

The configuration file describes the EC2 instances to provision. A representative configuration might look like:
```yaml
landscape:
  global:
    tags:
      Environment: prod
  instances:
    defaults:
      os_type: windows
      instance_type: r6i.4xlarge
      ami_id: ami-0d51758a4bd2afc6c
      keypair: kpadas
      instance_profile: cloud-IAMProfile-6MSV2PC9B6M1
      kms_key_id: 544d73e9-888b-4e0a-b5eb-5c87a0167eb8
      subnet_id: subnet-0fabde33d1a0f7e3e
      disk:
        volume_size: 100
        volume_type: gp3
        iops: 16000
        throughput: 1000
    servers:
      pgisapp00:
        tags:
          Application: GIS Application Server
        disks:
          C:
            name: C-Drive
            device_name: /dev/sda1
          D:
            name: D-Drive
            device_name: /dev/xvdf
      pgisdb00:
        type: linux
        ami_id: ami-0963fb6bf3306ed16
        tags:
          Application: GIS DB Server
        subnet_id: subnet-05bf6feba12f0fc51
        private_ip: 172.31.176.201
        secondary_ip_list:
          - 172.31.176.202
          - 172.31.176.203
        security_group_list:
          - sg-097f3ecc96c275abc
        instance_type: r7i.32xlarge
        disks:
          root:
            name: root disk
            device_name: /dev/sda1
            volume_size: 20
            iops: 3000
            throughput: 125
          hana_data:
            name: HANA data disk
            device_name: /dev/xvdg
            volume_size: 500
            iops: 7500
            throughput: 750
          hana_log:
            name: HANA log disk
            device_name: /dev/xvdh
            volume_size: 200
            iops: 12000
            throughput: 500
```
The configuration schema above allows defining a server landscape with a fleet of servers and their disk configurations using globally applicable values such as `tags`, instance and disk default attributes in `instances/defaults` that can be overridden at resource level as required. 

This configuration is simple specifically when default attributes are applicable (`pgisapp00`) while also allowing for complex server specifications (`pgisdb00`). It describes instances in terms of their logical attributes — name, compute profile, network placement, tags — without requiring the user to understand the full EC2 and EBS resource schemas. Adding a new instance is a matter of appending an entry to the list.
