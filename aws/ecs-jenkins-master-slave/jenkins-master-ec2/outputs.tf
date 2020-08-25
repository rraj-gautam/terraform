output "jenkins_ip"{
    value = aws_instance.jenkins-instance.public_ip
}
