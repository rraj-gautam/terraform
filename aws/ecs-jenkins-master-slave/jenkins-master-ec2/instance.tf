resource aws_instance "jenkins-instance" {
  ami                         = var.instance_ami
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [var.security_groups]
  key_name                    = var.key_name
  associate_public_ip_address = true
  #user_data                   = data.template_file.user_data.rendered

  tags = {
    "Name" = "${var.ecs_cluster_name}-master"
  }

  provisioner "local-exec" {
    command = <<EOT
    export ANSIBLE_HOST_KEY_CHECKING=False;
    sleep 90; 
    ansible-playbook -i ${aws_instance.jenkins-instance.public_ip}, -u ec2-user install.yml
    EOT
  }

}
