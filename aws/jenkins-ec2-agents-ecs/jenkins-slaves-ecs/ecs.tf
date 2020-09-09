resource "aws_ecs_cluster" "main" {
  name = var.ecs_cluster_name
  capacity_providers = [aws_ecs_capacity_provider.ecs_cap.name]

  tags = {
    "Name" = "${var.ecs_cluster_name}-cluster"
  }

  setting {
    name = "containerInsights"
    value = "enabled"
  }
}