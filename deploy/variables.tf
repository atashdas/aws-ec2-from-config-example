# variable "state_bucket" {
#   type        = string
#   description = "The Terraform state S3 bucket name."
# }

# variable "state_folder" {
#   type        = string
#   description = "The Terraform state folder name."
#   default     = "landing-zone"
# }

variable "config_file" {
  type        = string
  description = "The S3 key for the config file."
  default     = "desired_config.json"
}

# variable "region" {
#   type        = string
#   description = "The AWS region for deployment."
# }
