variable "region" {
  description = "AWS region to deploy resources in"
  type        = string
  default     = "eu-central-1"
}

# instance_type and ec2_volume_size are now set per-environment in locals.tf
# (see local.env_config), keyed by the active workspace.

variable "ec2_volume_type" {
  description = "Type of the root EBS volume"
  type        = string
  default     = "gp3"
}
