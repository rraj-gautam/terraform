# logs.tf

# Set up CloudWatch group and log stream and retain logs for 30 days
resource "aws_cloudwatch_log_group" "cb_log_group" {
  name              = "/ecs/clamav-app"
  retention_in_days = var.cloudwatch_retention

  tags = merge(var.tags, map(
    "Name", "${var.name}-log-group"
  ))
}

resource "aws_cloudwatch_log_stream" "cb_log_stream" {
  name           = "clamav-log-stream"
  log_group_name = aws_cloudwatch_log_group.cb_log_group.name
}