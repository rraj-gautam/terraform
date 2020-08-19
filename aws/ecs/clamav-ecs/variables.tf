
variable "aws_region" {
  description = "The AWS region things are created in"
  default     = "eu-central-1"
}

variable "ecs_task_execution_role_name" {
  description = "ECS task execution role name"
  default = "myEcsTaskExecutionRole"
}

variable "ecs_auto_scale_role_name" {
  description = "ECS auto scale role Name"
  default = "myEcsAutoScaleRole"
}

variable "az_count" {
  description = "Number of AZs to cover in a given region"
  default     = "1"
}

variable "app_image" {
  description = "Docker image to run in the ECS cluster"
  #default     = "rraj4/clamav:alpine"
  default = "502382556974.dkr.ecr.us-east-1.amazonaws.com/clamav:alpine"
}

variable "app_port" {
  description = "Port exposed by the docker image to redirect traffic to"
  default     = 3310
}

variable "app_count" {
  description = "Number of docker containers to run"
  default     = 1
}

variable "health_check_path" {
  default = "/"
}

variable "fargate_cpu" {
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
  default     = "1024"
}

variable "fargate_memory" {
  description = "Fargate instance memory to provision (in MiB)"
  default     = "2048"
}

variable "ecs_public_subnet_ids" {
  description = "Subnet ids to link the ecs service"
  #default     = ["subnet-b79edfca"]
}
variable "ecs_private_subnet_ids" {
  description = "Subnet ids to link the ecs service"
}
variable "vpc_id" {
  description = "VPC id"
}

# variable "client_sg_cidr" {
#   description = "CIDR range for client sg"
#   type        = list(string)
# }

variable "tags" {
  description = "Resource Tags"
  default     = {}
}

variable "name" {
  description = "Name for stack"
  default     = "clamav"
}

variable "cloudwatch_retention" {
  description = "CloudWatch Retention Period"
  default     = 30
}
