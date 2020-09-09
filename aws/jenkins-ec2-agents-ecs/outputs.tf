output "jenkins_pub_ip"{
    value = module.jenkins-master.jenkins_pub_ip
}

output "jenkins_priv_ip"{
    value = module.jenkins-master.jenkins_priv_ip
}

output "elb_hostname" {
    value = module.jenkins-master.elb_hostname
}