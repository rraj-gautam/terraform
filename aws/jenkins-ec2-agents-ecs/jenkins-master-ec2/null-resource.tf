# resource "null_resource" "test_provisioner" {
# #   triggers = {
# #     public_ip = aws_instance.test-instance-web.public_ip
# #   }

#   provisioner "local-exec" {
#     command = <<EOT
#     export ANSIBLE_HOST_KEY_CHECKING=False;
#     sleep 90; 
#     ansible-playbook -i ${aws_elb.jenkins.dns_name}, -u ec2-user install.yml
#     EOT
#   }

#   depends_on = [aws_elb.jenkins,aws_instance.jenkins-instance]
# }