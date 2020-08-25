# data "aws_iam_policy_document" "ecs_agent" {
#   statement {
#     actions = ["sts:AssumeRole"]

#     principals {
#       type        = "Service"
#       identifiers = ["ec2.amazonaws.com"]
#     }
#   }
# }

# resource "aws_iam_role" "ecs_agent" {
#   name               = "${var.ecs_cluster_name}_ecs-agent"
#   assume_role_policy = data.aws_iam_policy_document.ecs_agent.json
# }


# resource "aws_iam_role_policy_attachment" "ecs_agent" {
#   role       = "aws_iam_role.ecs_agent.name
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
# }
# resource "aws_iam_instance_profile" "ecs_agent" {
#   name = "${var.ecs_cluster_name}_ecs-agent"
#   role = aws_iam_role.ecs_agent.name
# }



resource "aws_iam_role" "ecs_host_role" {
    name = "ecs_host_role"
    assume_role_policy = file("${path.module}/policies/ecs-role.json")
}

resource "aws_iam_role_policy" "ecs_instance_role_policy" {
    name = "ecs_instance_role_policy"
    policy = file("${path.module}/policies/ecs-instance-role-policy.json")
    role = aws_iam_role.ecs_host_role.id
}

resource "aws_iam_role" "ecs_service_role" {
    name = "ecs_service_role"
    assume_role_policy = file("${path.module}/policies/ecs-role.json")
}

resource "aws_iam_role_policy" "ecs_service_role_policy" {
    name = "ecs_service_role_policy"
    policy = file("${path.module}/policies/ecs-service-role-policy.json")
    role = aws_iam_role.ecs_service_role.id
}

resource "aws_iam_instance_profile" "ecs_agent" {
    name = "ecs-instance-profile"
    path = "/"
    role = aws_iam_role.ecs_host_role.name
}