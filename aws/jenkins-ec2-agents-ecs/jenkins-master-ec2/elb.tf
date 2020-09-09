resource "aws_elb" "jenkins" {
  name               = "${var.ecs_cluster_name}-elb"
  #availability_zones = ["us-east-1a", "us-east-1b"]
  subnets = [var.elb_subnet_id]
  security_groups = [var.security_groups]

  # access_logs {
  #   bucket        = "manish-logs"
  #   bucket_prefix = "jenkins-logs"
  #   interval      = 60
  # }

  listener {
    instance_port     = 8080
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
  
  listener {
    instance_port     = 22
    instance_protocol = "tcp"
    lb_port           = 22
    lb_protocol       = "tcp"
  }
    

#   listener {
#     instance_port      = 8080
#     instance_protocol  = "http"
#     lb_port            = 443
#     lb_protocol        = "https"
#     ssl_certificate_id = "arn:aws:iam::123456789012:server-certificate/certName"
#   }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "TCP:8080"
    interval            = 30
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = "${var.ecs_cluster_name}-elb"
  }
}

resource "aws_elb_attachment" "jenkins-elb-attachment" {
  elb      = aws_elb.jenkins.id
  instance = aws_instance.jenkins-instance.id
  #instances                   = [aws_instance.jenkins-instances.id]
}
