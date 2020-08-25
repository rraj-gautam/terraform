data "aws_availability_zones" "available" {}

data "terraform_remote_state" "ecs" {
  backend = "s3"
  config = {
    bucket = "manish-terraform-states"
    key    = "clamav.tfstate"
    region = "us-east-1"
  }
}

#data "terraform_remote_state" "vpc" {
#  backend = "local"
#
#  config = {
#    path = "../vpc/terraform.tfstate"
#  }
#}

data "aws_vpc" "this" {
  id = data.terraform_remote_state.ecs.outputs.vpc_id
}

data "aws_subnet" "public" {
  vpc_id = data.aws_vpc.this.id

  filter {
    name   = "tag:Name"
    values = ["*pub-2*"]
  }
}

data "aws_subnet_ids" "private" {
  vpc_id = data.aws_vpc.this.id

  filter {
    name   = "tag:Name"
    values = ["*priv*"]
  }
}

data "aws_subnet_ids" "public" {
  vpc_id = data.aws_vpc.this.id

  filter {
    name   = "tag:Name"
    values = ["*pub*"]
  }
}

data "template_file" "user_data" {
  template = file("./install-scripts/install-ubuntu.sh")
}