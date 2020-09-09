resource "aws_efs_file_system" "jenkins-agent-efs" {
   creation_token = var.ecs_cluster_name
   performance_mode = "generalPurpose"
   throughput_mode = "bursting"
   encrypted = "true"
 tags = {
     Name = "${var.ecs_cluster_name}-efs"
   }
 }

 resource "aws_efs_mount_target" "jenkins-agent-efs-mt" {
   file_system_id  = aws_efs_file_system.jenkins-agent-efs.id
   subnet_id = data.aws_subnet.private-2.id
   security_groups = [aws_security_group.ingress-efs-jenkins.id]
 }