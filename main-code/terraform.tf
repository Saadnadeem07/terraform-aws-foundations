terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  backend "s3" {
    bucket = "tf-backup-bucket-sn-7223"
    region = "eu-central-1"
    key    = "terraform.tfstate"
    dynamodb_table = "tf_backup_db"
    
  }
}