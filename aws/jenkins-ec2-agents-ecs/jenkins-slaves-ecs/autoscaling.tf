resource "aws_launch_configuration" "ecs_launch_config" {
    name = "${var.ecs_cluster_name}-launch-configuration"
    image_id             = var.agent_ami  #"ami-02cfc1ae415add4ce"
    iam_instance_profile = aws_iam_instance_profile.ecs_hudson_agent.name
    security_groups      = [var.security_groups]
    instance_type        = var.instance_type #"t2.small"
    key_name = var.key_name
    associate_public_ip_address = false
    #user_data = "#!/bin/bash\necho ECS_CLUSTER='${var.ecs_cluster_name}' > /etc/ecs/ecs.config"
    user_data = base64encode(var.user_data)

    # root_block_device {
    #    delete_on_termination = true
    #    encrypted             = false
    #    volume_size           = "30"
    #    volume_type           = "gp2"
    # }
    lifecycle {
    ignore_changes = [
      user_data
    ]
  } 

}

resource "aws_autoscaling_group" "ecs_asg" {
    #availability_zones = ["${var.availability_zone}"]
    name                      = "${var.ecs_cluster_name}_asg"
    vpc_zone_identifier       = [var.subnet_id]
    launch_configuration      = aws_launch_configuration.ecs_launch_config.name

    desired_capacity          = 1
    min_size                  = 1
    max_size                  = 5
    health_check_grace_period = 60
    health_check_type         = "EC2"
    protect_from_scale_in     = true

    tag {
    key                 = "Name"
    value               = var.ecs_cluster_names
    propagate_at_launch = true
    }

  dynamic "tag" {
    for_each = var.isotags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }    
}

resource "aws_ecs_capacity_provider" "ecs_cap" {
  name = "${var.ecs_cluster_name}_cap"

  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.ecs_asg.arn
    managed_termination_protection = "ENABLED"

    managed_scaling {
        maximum_scaling_step_size = 1000
        minimum_scaling_step_size = 1
        status                    = "ENABLED"
        target_capacity           = 90
    }
  }
}

#### cloudwatch and autoscaling up/down policies are old methods of scaling cluster. (can be done based on CPU/Memory utilization)
#### For clusers to scale on basis of tasks, capacity providers are newer methods released/

# resource "aws_autoscaling_policy" "agents-scale-up" {
#     name = "${var.ecs_cluster_name}_scale_up"
#     scaling_adjustment = 1
#     adjustment_type = "ChangeInCapacity"
#     cooldown = 60
#     autoscaling_group_name = aws_autoscaling_group.ecs_asg.name
# }

# resource "aws_autoscaling_policy" "agents-scale-down" {
#     name = "${var.ecs_cluster_name}_scale_down"
#     scaling_adjustment = -1
#     adjustment_type = "ChangeInCapacity"
#     cooldown = 60
#     autoscaling_group_name = aws_autoscaling_group.ecs_asg.name
# }
