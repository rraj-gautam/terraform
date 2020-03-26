sudo yum install telnet unzip wget -y
sed -i s/^SELINUX=.*$/SELINUX=disabled/ /etc/selinux/config
setenforce 0
yum install https://repo.aerisnetwork.com/stable/centos/7/x86_64/aeris-release-1.0-4.el7.noarch.rpm -y
yum install nginx-more -y
systemctl enable --now nginx
