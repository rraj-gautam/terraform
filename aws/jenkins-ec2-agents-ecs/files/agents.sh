#!/bin/bash
sudo yum update -y
mkdir /jenkins_data
chmod 777 /var/run/docker.sock

#install ssm-agent
sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
sudo service amazon-ssm-agent start

#install nfs and mount efs disk
sudo yum install -y nfs-utils
sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport ${efs_hostname}:/ /jenkins_data
chmod 777 /jenkins_data -R

#install awscli
sudo yum install unzip -y
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && unzip awscliv2.zip && /bin/sh ./aws/install


##to join as ecs container agent
# view current version running: curl -s 127.0.0.1:51678/v1/metadata | python -mjson.tool
sudo mkdir -p /etc/ecs && sudo touch /etc/ecs/ecs.config
cat > /etc/ecs/ecs.config << EOF
ECS_DATADIR=/data
ECS_ENABLE_TASK_IAM_ROLE=true
ECS_ENABLE_TASK_IAM_ROLE_NETWORK_HOST=true
ECS_LOGFILE=/log/ecs-agent.log
ECS_AVAILABLE_LOGGING_DRIVERS=["json-file","awslogs"]
ECS_LOGLEVEL=info
ECS_ENABLE_CONTAINER_METADATA=true
ECS_CLUSTER=${ecs_cluster_name}
EOF

#### To manually update ecs-agent:
# docker stop ecs-agent
# docker rm -f  ecs-agent
# docker rmi amazon/amazon-ecs-agent
# docker pull amazon/amazon-ecs-agent

# sudo docker run --name ecs-agent \
# --detach=true \
# --restart=on-failure:10 \
# --volume=/var/run:/var/run \
# --volume=/var/log/ecs/:/log \
# --volume=/var/lib/ecs/data:/data \
# --volume=/etc/ecs:/etc/ecs \
# --net=host \
# --env-file=/etc/ecs/ecs.config \
# amazon/amazon-ecs-agent:latest