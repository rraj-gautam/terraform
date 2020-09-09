resource "aws_s3_bucket" "test-bucket" {
  bucket = "manish-bucket-test-env"
  acl    = "private"
  versioning {
    enabled = true
  }

  lifecycle_rule {
    id      = "retention"
    enabled = true

    expiration {
      days = 720
    }
    noncurrent_version_expiration {
      days = 720
    }
  }

  tags = {
    Name        = "manish-bucke-test-env"
    Environment = "test"
  }
}
