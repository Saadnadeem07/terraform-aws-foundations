resource "aws_s3_bucket" "backup-bucket" {
  bucket = "tf-backup-bucket-sn-7223"

  tags = {
    Name        = "tf-backup-bucket-sn-7223"
  }
}