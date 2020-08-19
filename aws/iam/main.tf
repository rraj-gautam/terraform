provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

resource "aws_iam_user" "tf" {
  name = "terraform"
   path = "/"

  tags = {
    env = "test"
  }
}

resource "aws_iam_access_key" "tf" {
  user = aws_iam_user.tf.name
}

resource "aws_iam_user_policy" "tf-policy" {
  name = "tf-policy"
  user = aws_iam_user.tf.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:Describe*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

# resource "aws_iam_user" "spider" {
#     arn       = "arn:aws:iam::502382556974:user/spider"
#     id        = "spider"
#     name      = "spider"
#     path      = "/"
#     tags      = {
#         "type" = "playground"
#     }
#     unique_id = "AIDAXJ6CVO4XHE4QJYNRT"
# }

locals {
test_account_id = "560741375117"
stage_account_id = "385759858167"
prod_account_id = "663831524380"
v3_dev_id = "837719825519"
v3_live_id = "618086408017"
}

resource "aws_iam_role" "ecr_role" {
  name = "ecr_role"

  assume_role_policy = <<-EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": [
          "arn:aws:iam::${local.test_account_id}:root"
        ]
      },
      "Action": "sts:AssumeRole",
      "Condition": {}
    }
  ]
}
  EOF
}

resource "aws_iam_role_policy" "ecr_policy" {
  name = "ecr_policy"
  role = aws_iam_role.ecr_role.id

  policy = <<-EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ecr:GetAuthorizationToken",
                "ecr:BatchCheckLayerAvailability",
                "ecr:GetDownloadUrlForLayer",
                "ecr:GetRepositoryPolicy",
                "ecr:DescribeRepositories",
                "ecr:ListImages",
                "ecr:DescribeImages",
                "ecr:BatchGetImage",
                "ecr:GetLifecyclePolicy",
                "ecr:GetLifecyclePolicyPreview",
                "ecr:ListTagsForResource",
                "ecr:DescribeImageScanFindings",
                "ecr:InitiateLayerUpload",
                "ecr:UploadLayerPart",
                "ecr:CompleteLayerUpload",
                "ecr:PutImage"
            ],
            "Resource": "*"
        }
    ]
}
  EOF
}
