locals {
  # The active workspace IS the environment name (dev / prod).
  env = terraform.workspace

  # Per-environment settings. Add a key here for every workspace you create.
  env_config = {
    dev = {
      instance_type   = "t2.micro"
      ec2_volume_size = 10
      instance_count  = 1
    }
    prod = {
      instance_type   = "t2.medium"
      ec2_volume_size = 30
      instance_count  = 2
    }
  }

  is_known_env = contains(keys(local.env_config), local.env)

  # In a known workspace use its settings. Otherwise fall back to a safe,
  # zero-instance config so `validate`/`plan` don't crash on null — the
  # precondition below stops any real apply in an unknown workspace.
  config = local.is_known_env ? local.env_config[local.env] : {
    instance_type   = "t2.micro"
    ec2_volume_size = 10
    instance_count  = 0
  }
}

# Guard: stop the apply if someone runs this in a workspace we don't know about
# (e.g. the "default" workspace).
resource "terraform_data" "validate_workspace" {
  lifecycle {
    precondition {
      condition     = local.is_known_env
      error_message = "Unknown workspace '${local.env}'. Run in one of: ${join(", ", keys(local.env_config))}. Use `terraform workspace select <env>`."
    }
  }
}
