resource "aws_s3_bucket" "backup_bucket" {
  bucket = "tf-backup-bucket"

  tags = {
    Name        = "tf-backup-bucket"
  }
}