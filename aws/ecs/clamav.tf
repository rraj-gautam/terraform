provider "aws" {
  profile = "default"
  region  = "us-east-1"
}


module "clamav" {
 
  source = "./clamav-ecs"
  ecs_private_subnet_ids = data.aws_subnet_ids.private.ids
  ecs_public_subnet_ids = data.aws_subnet_ids.public.ids
  vpc_id         = data.aws_vpc.this.id

  fargate_cpu          = 1024
  fargate_memory       = 2048
  az_count             = 1
  app_count            = 1
  cloudwatch_retention = 30

  tags = {
    owner = "rishi.gautam@itonics.de"
  }
}   
