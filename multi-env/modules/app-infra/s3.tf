resource "aws_s3_bucket" "backup-bucket" {
  bucket = "${var.env}-infra-app-s3"

  tags = {
    Name        = "${var.env}-infra-app-s3"
    environment = var.env
  }
}