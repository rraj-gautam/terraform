module "jenkins-master" {
  source           = "./jenkins-master-ec2"
  instance_ami     = var.instance_ami
  instance_type    = var.instance_type
  ecs_cluster_name = "hudson"
  security_groups = aws_security_group.sg_jenkins.id
  subnet_id = data.aws_subnet.private-2.id
  private_subnet_id = data.aws_subnet_ids.private.id #this is for optional way to specify subnet id for instance
  elb_subnet_id = data.aws_subnet.public-2.id
  key_name = var.key_name
}

module "jenkins-slaves" {
  source                = "./jenkins-slaves-ecs"
  subnet_id             = data.aws_subnet.private-2.id
  ecs_cluster_name      = var.ecs_cluster_name
  security_groups       = aws_security_group.sg_jenkins.id
  key_name              = var.key_name
  instance_type         = var.agent_instance_type
  agent_ami             = data.aws_ami.ecs.id
  user_data             = templatefile("./files/agents.sh", { ecs_cluster_name = "${var.ecs_cluster_name}", efs_hostname = "${local.efs_hostname}" })
  
  isotags = {
    "Description"             = "Jenkins ECS Cluster"
    "Employee Data"           = "N"
    "Employee Sensitive Data" = "N"
    "Customer Sensitive Data" = "N"
    "Confidentiality"         = "Confidential"
    "Integrity"               = ""
    "Availability"            = "High"
    "Data Retention Period"   = "N/A"
    "Backup Frequency"        = ""
    "Impact Of Disclosure"    = ""
    "Process Owner"           = "thunderdfrost@gmail.com"
  }
}


locals {
  efs_hostname = aws_efs_file_system.jenkins-agent-efs.dns_name
}

data "aws_ami" "ecs" {
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-2.0.*-x86_64-ebs"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["amazon"]
}