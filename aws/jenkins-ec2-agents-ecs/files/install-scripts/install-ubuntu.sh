#!/bin/bash
sudo apt update -y

echo "Install Java JDK 8"
sudo apt install openjdk-8-jdk -y

echo "Install Maven"
apt install -y maven 

echo "Install git"
apt install -y git

echo "Install Ansible"
sudo apt-add-repository ppa:ansible/ansible
sudo apt update -y
sudo apt install ansible -y

echo "Install Docker engine"
sudo apt -y install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
apt update -y
sudo apt-get install docker-ce docker-ce-cli containerd.io       

echo "Install Jenkins"
wget –q –O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add –
echo "deb https://pkg.jenkins.io/debian binary" >> /etc/apt/sources.list
apt update -y 
sudo apt install Jenkins -y 

sudo usermod -a -G docker jenkins
sudo systemctl enable jenkins
sudo service docker start
sudo service jenkins start

echo $(cat /var/lib/jenkins/secrets/initialAdminPassword)
