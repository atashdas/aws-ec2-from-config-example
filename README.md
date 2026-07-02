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

The `modules/my-ec2-instance/` directory contains the provider-specific implementation. The `config/` directory contains the operator-facing configuration. The `deploy/` layer wires the two together.
