resource "aws_launch_configuration" "ecs_launch_config" {
    image_id             = "ami-02cfc1ae415add4ce"
    iam_instance_profile = aws_iam_instance_profile.ecs_agent.name
    security_groups      = [var.security_groups]
    #user_data            = file("./install.sh")
    instance_type        = "t2.small"
    key_name = var.key_name
    associate_public_ip_address = true
    user_data = << EOT
    	#!/bin/bash
    	echo ECS_CLUSTER='${var.stack_name}' > /etc/ecs/ecs.config
    	chmod 777 /var/run/docker.sock
    	mkdir /jenkins
    	chmod 777 /jenkins -R
    EOT
}

resource "aws_autoscaling_group" "failure_analysis_ecs_asg" {
    #availability_zones = ["${var.availability_zone}"]
    name                      = "${var.ecs_cluster_name}_asg"
    vpc_zone_identifier       = [var.subnet_id]
    launch_configuration      = aws_launch_configuration.ecs_launch_config.name

    desired_capacity          = 2
    min_size                  = 1
    max_size                  = 5
    health_check_grace_period = 300
    health_check_type         = "EC2"
}
