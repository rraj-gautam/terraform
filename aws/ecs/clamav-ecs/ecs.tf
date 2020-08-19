
resource "aws_ecs_cluster" "main" {
  name = "clamav-cluster"

  tags = merge(var.tags, map(
    "Name", "${var.name}-cluster"
  ))

  setting {
    name = "containerInsights"
    value = "enabled"
  }
}

data "template_file" "cb_app" {
  template = file("${path.module}/task_definition.json")

  vars = {
    app_image      = var.app_image
    app_port       = var.app_port
    fargate_cpu    = var.fargate_cpu
    fargate_memory = var.fargate_memory
    aws_region     = var.aws_region

  }
}

resource "aws_ecs_task_definition" "app" {
  family                   = "clamav-app-task"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  container_definitions    = data.template_file.cb_app.rendered

  tags = merge(var.tags, map(
    "Name", "${var.name}-task-definition"
  ))
}

resource "aws_ecs_service" "main" {
  name             = "clamav-service"
  cluster          = aws_ecs_cluster.main.id
  task_definition  = aws_ecs_task_definition.app.arn
  desired_count    = var.app_count
  launch_type      = "FARGATE"
  platform_version = "1.4.0"


  network_configuration {
    security_groups  = [aws_security_group.ecs_lb_sg.id]
    #security_groups  = [aws_security_group.ecs_tasks_sg.id]
    subnets          = var.ecs_private_subnet_ids
    #subnets          = data.aws_subnet_ids.public.id
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.app.id
    container_name   = "clamav"
    container_port   = var.app_port
  }

  depends_on = [aws_ecs_task_definition.app, aws_alb_listener.front_end, aws_iam_role_policy_attachment.ecs_task_execution_role]
  
}
