resource aws_instance "jenkins-instance" {
  ami                         = var.instance_ami
  instance_type               = var.instance_type
  #subnet_id                   = var.subnet_id 
  #or
  subnet_id = join(
    ",",
    slice(
      split(",", var.private_subnet_id),
      0,
      length(split(",", var.private_subnet_id)) - 1,
    ), 
  )
  vpc_security_group_ids      = [var.security_groups]
  key_name                    = var.key_name
  associate_public_ip_address = false
  #user_data                   = data.template_file.user_data.rendered

  tags = {
    "Name" = "${var.ecs_cluster_name}-master"
    "Employee Data" = "N"
    "Employee Sensitive Data" = "N"
    "Customer Sensitive Data" = "N"
    "Confidentiality" = "Strictly Confidential"
    "Impact of Disclosure" = "High"
    "Availability" = "High"
    "Data Retention Period" = "N/A" 
    "Description" = "Jenkins CI/CD Server"
    "Integrity" = "N/A"
    "Backup Frequency" = "Daily"
    "Process Owner" = "Rishi Raj Gautam"
  }

  # provisioner "local-exec" {
  #   command = <<EOT
  #   export ANSIBLE_HOST_KEY_CHECKING=False;
  #   sleep 90; 
  #   ansible-playbook -i ${aws_instance.jenkins-instance.public_ip}, -u ec2-user install.yml
  #   EOT
  # }

}