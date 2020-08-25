variable "instance_ami" {
  default = "ami-098f16afa9edf40be"
  #default = "ami-0bcc094591f354be2"
}
variable "instance_type" {
  description = "type for aws EC2 instance"
  default     = "t2.small"
}

variable "key_name" {
  default = "rraj"
}

variable "region" {
  description = "The AWS region to create resources in."
  default     = "us-east-1"
}

variable "ecs_cluster_name" {
  description = "The name of the Amazon ECS cluster."
  default     = "jenkins"
}

variable "aws_region" {
  description = "The AWS region things are created in"
  default     = "us-east-1"
}

variable "tags" {
  description = "Resource Tags"
  default = {
    owner = "rishi.gautam@itonics.de"
  }
}

variable "stack_name" {
  description = "Name for stack"
  default     = "jenkins-agents"
}

# variable "cloudwatch_retention" {
# description = "CloudWatch Retention Period"
# default     = 30
# }