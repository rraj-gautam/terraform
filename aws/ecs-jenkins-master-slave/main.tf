module "jenkins-master" {
  source           = "./jenkins-master-ec2"
  instance_ami     = var.instance_ami
  instance_type    = var.instance_type
  ecs_cluster_name = var.ecs_cluster_name
  security_groups = aws_security_group.sg_jenkins.id
  subnet_id = data.aws_subnet.public.id
  key_name = var.key_name
}

module "jenkins-slaves" {
  source                = "./jenkins-slaves-ecs"
  stack_name            = var.stack_name
  subnet_id = data.aws_subnet.public.id
  ecs_public_subnet_ids = data.aws_subnet_ids.public.ids
  ecs_cluster_name      = var.ecs_cluster_name
  security_groups       = aws_security_group.sg_jenkins.id
  key_name = var.key_name
}