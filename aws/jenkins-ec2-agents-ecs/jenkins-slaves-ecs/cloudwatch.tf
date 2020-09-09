# resource "aws_cloudwatch_metric_alarm" "memory-high" {
#     alarm_name = "${var.ecs_cluster_name}_high_memory"
#     comparison_operator = "GreaterThanOrEqualToThreshold"
#     evaluation_periods = "2"
#     metric_name = "MemoryUtilization"
#     namespace = "System/Linux"
#     period = "120"
#     statistic = "Average"
#     threshold = "80"
#     alarm_description = "This metric monitors ec2 memory for high utilization on agent hosts"
#     alarm_actions = [
#         aws_autoscaling_policy.agents-scale-up.arn
#     ]
#     dimensions = {
#         AutoScalingGroupName = "${aws_autoscaling_group.ecs_asg.name}"
#     }
# }

# resource "aws_cloudwatch_metric_alarm" "memory-low" {
#     alarm_name = "mem-util-low-agents"
#     comparison_operator = "LessThanOrEqualToThreshold"
#     evaluation_periods = "2"
#     metric_name = "MemoryUtilization"
#     namespace = "System/Linux"
#     period = "300"
#     statistic = "Average"
#     threshold = "40"
#     alarm_description = "This metric monitors ec2 memory for low utilization on agent hosts"
#     alarm_actions = [
#         aws_autoscaling_policy.agents-scale-down.arn
#     ]
#     dimensions = {
#         AutoScalingGroupName = "${aws_autoscaling_group.ecs_asg.name}"
#     }
# }