# Traffic to the ECS cluster should only come from the ALB
resource "aws_security_group" "ecs_lb_sg" {
  name        = "clamav-ecs-tasks-security-group"
  description = "ClamAV ECS Task Network Security Group"
  vpc_id      = var.vpc_id

  ingress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, map(
    "Name", "${var.name}-sg"
  ))
}

resource "aws_security_group" "ecs_tasks_sg" {
  name        = "clamav-client-security-group"
  description = "ClamAV Client Network Security Group"
  vpc_id      = var.vpc_id

  ingress {
    protocol        = "tcp"
    from_port       = var.app_port
    to_port         = var.app_port
    security_groups = [aws_security_group.ecs_lb_sg.id]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, map(
    "Name", "${var.name}-client-sg"
  ))
}
