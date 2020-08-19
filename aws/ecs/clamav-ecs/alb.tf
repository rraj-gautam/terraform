resource "aws_alb" "main" {
  name            = "clamav-load-balancer"
  subnets         = var.ecs_public_subnet_ids
  internal           = true
  load_balancer_type = "network"
  #security_groups = ["aws_security_group.ecs_lb_sg.id"]

  tags = merge(var.tags, map(
    "Name", "${var.name}-internal-lb"
  ))
}

resource "aws_alb_target_group" "app" {
  name        = "clamav-target-group"
  port        = 3310
  protocol    = "TCP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  tags = merge(var.tags, map(
    "Name", "${var.name}-target-group"
  ))
}

# Redirect all traffic from the ALB to the target group
resource "aws_alb_listener" "front_end" {
  load_balancer_arn = aws_alb.main.id
  port              = var.app_port
  protocol          = "TCP"

  default_action {
    target_group_arn = aws_alb_target_group.app.id
    type             = "forward"
  }
}
