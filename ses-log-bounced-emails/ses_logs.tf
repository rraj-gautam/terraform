# SES Domain Identity
resource "aws_ses_domain_identity" "domain" {
  domain = "sysdaemons.com"
}

resource "aws_ses_identity_notification_topic" "bounce" {
  topic_arn                = aws_sns_topic.ses-config.arn
  notification_type        = "Bounce"
  identity                 = aws_ses_domain_identity.domain.domain
  include_original_headers = true
}

resource "aws_ses_identity_notification_topic" "complaint" {
  topic_arn                = aws_sns_topic.ses-config.arn
  notification_type        = "Complaint"
  identity                 = aws_ses_domain_identity.domain.domain
  include_original_headers = true
}

# #SES Configuration
# resource "aws_ses_configuration_set" "ses_config" {
#   name = "smtp-dev"
# }

# resource "aws_ses_event_destination" "destination_sns" {
#   name                   = "ses-config-event-to-sns"
#   configuration_set_name = aws_ses_configuration_set.ses_config.name
#   enabled                = true
#   matching_types         = ["reject", "send"]

#   sns_destination {
#     topic_arn = aws_sns_topic.ses-config.arn
#   }
# }

#SNS Topic
resource "aws_sns_topic" "ses-config" {
  name = "ses-config-events"
}

resource "aws_sns_topic_policy" "ses-config" {
  arn    = aws_sns_topic.ses-config.arn
  policy = data.aws_iam_policy_document.ses_sns_topic_policy.json
}

data "aws_iam_policy_document" "ses_sns_topic_policy" {
  statement {
    effect  = "Allow"
    actions = ["SNS:Publish"]

    principals {
      type        = "Service"
      identifiers = ["ses.amazonaws.com"]
    }

    resources = [aws_sns_topic.ses-config.arn]
  }
}


#lambda
resource "aws_iam_role" "iam_for_lambda" {
  name = "ses-config-lambda-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambdaPolicy" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

data "archive_file" "init" {
  type        = "zip"
  source_file = "${path.module}/index.py"
  output_path = "${path.module}/index.zip"
}

resource "aws_lambda_function" "ses_lambda" {
  filename      = "${path.module}/index.zip"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "index.lambda_handler"
  function_name = local.ses_log_lambda_name

  source_code_hash = data.archive_file.init.output_base64sha256

  runtime = "python3.6"
}

#cloudwatch log group
resource "aws_cloudwatch_log_group" "loggroup" {
  name              = "/aws/lambda/${local.ses_log_lambda_name}"
  retention_in_days = 60
}

#Adding lambda to SNS subscription
resource "aws_sns_topic_subscription" "sns-lambda-subscribe" {
  topic_arn = aws_sns_topic.ses-config.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.ses_lambda.arn
}

resource "aws_lambda_permission" "sns_lambda_permission" {
  statement_id = "AllowExecutionFromSNS"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.ses_lambda.arn
  principal = "sns.amazonaws.com"
  source_arn = aws_sns_topic.ses-config.arn
}

locals {
  ses_log_lambda_name = "ses-smtp-logs"
}
