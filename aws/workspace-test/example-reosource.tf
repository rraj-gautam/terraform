resource "aws_s3_bucket" "test-bucket-workspace" {
  bucket = "manish-bucket-test-workspace"
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
    Name        = "manish-bucke-test-workspace"
    Environment = "test"
  }
}
