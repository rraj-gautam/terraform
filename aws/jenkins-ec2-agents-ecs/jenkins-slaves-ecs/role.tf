data "aws_iam_policy_document" "ecs_agent" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_agent" {
  name               = "${var.ecs_cluster_name}_ecs-agent"
  assume_role_policy = data.aws_iam_policy_document.ecs_agent.json
}

#for ec2-ecs
resource "aws_iam_role_policy_attachment" "ecs_agent" {
  role       = "aws_iam_role.ecs_agent.name"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

#for ec2-ssm
resource "aws_iam_role_policy_attachment" "ecs_agent" {
  role       = "aws_iam_role.ecs_agent.name"
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ecs_agent" {
  name = "${var.ecs_cluster_name}_ecs-agent"
  role = aws_iam_role.ecs_agent.name
}


#### another way of adding role and policies

# resource "aws_iam_role" "ecs_hudson_role" {
#     name = "ecs_hudson_role"
#     assume_role_policy = file("${path.module}/policies/ecs-role.json")
# }

# resource "aws_iam_role_policy" "hudson_instance_role_policy" {
#     name = "hudson_instance_role_policy"
#     policy = file("${path.module}/policies/ecs-instance-role-policy.json")
#     role = aws_iam_role.ecs_hudson_role.id
# }

# resource "aws_iam_role" "hudson_service_role" {
#     name = "hudson_service_role"
#     assume_role_policy = file("${path.module}/policies/ecs-role.json")
# }

# resource "aws_iam_role_policy" "hudson_service_role_policy" {
#     name = "hudson_service_role_policy"
#     policy = file("${path.module}/policies/ecs-service-role-policy.json")
#     role = aws_iam_role.hudson_service_role.id
# }

# resource "aws_iam_instance_profile" "ecs_hudson_agent" {
#     name = "ecs-hudson-instance-profile"
#     path = "/"
#     role = aws_iam_role.ecs_hudson_role.name
# }