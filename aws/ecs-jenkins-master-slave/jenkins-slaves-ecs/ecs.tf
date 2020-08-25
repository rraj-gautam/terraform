resource "aws_ecs_cluster" "main" {
  name = var.stack_name

  tags = {
    "Name" = "${var.stack_name}-cluster"
  }

  setting {
    name = "containerInsights"
    value = "enabled"
  }
}