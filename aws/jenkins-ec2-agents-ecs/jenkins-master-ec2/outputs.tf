output "jenkins_pub_ip"{
    value = aws_instance.jenkins-instance.public_ip
}

output "jenkins_priv_ip"{
    value = aws_instance.jenkins-instance.private_ip
}
output "elb_hostname" {
    value = aws_elb.jenkins.dns_name
}