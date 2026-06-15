# Configure the AWS Provider
provider "aws" {
  region = var.region

  # Stamp every resource with the environment so dev/prod are easy to tell apart.
  default_tags {
    tags = {
      Environment = local.env
      ManagedBy   = "terraform"
    }
  }
}
