data "aws_caller_identity" "current" {}

resource "aws_cloudtrail" "testtrail" {
  name                          = "tf-trail"
  s3_bucket_name                = aws_s3_bucket.trail-bucket.id
  s3_key_prefix                 = "prefix"
  include_global_service_events = false

  event_selector {
    include_management_events = true
    read_write_type           = "All"
  }
  event_selector {
    include_management_events = false
    read_write_type           = "WriteOnly"
    data_resource {
      type   = "AWS::S3::Object"
      values = [
        "arn:aws:s3:::"
      ]
    }
  }
}

resource "aws_s3_bucket" "trail-bucket" {
  bucket        = "manish-cloudtrail"
  force_destroy = true

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AWSCloudTrailAclCheck",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:GetBucketAcl",
            "Resource": "arn:aws:s3:::manish-cloudtrail"
        },
        {
            "Sid": "AWSCloudTrailWrite",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::manish-cloudtrail/prefix/AWSLogs/${data.aws_caller_identity.current.account_id}/*",
            "Condition": {
                "StringEquals": {
                    "s3:x-amz-acl": "bucket-owner-full-control"
                }
            }
        }
    ]
}
POLICY
}
