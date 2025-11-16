#!/bin/bash
#--------------Server configuration---------------#
HOSTNAME="prod-todo-bastion"
hostnamectl set-hostname ${HOSTNAME}
chown -R ubuntu:ubuntu /home/ubuntu

#--------------Install docker--------------#
apt-get update
apt-get install -y cloud-utils apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
apt-get update
apt-get install -y docker-ce
usermod -aG docker ubuntu
systemctl start docker
systemctl enable docker
newgrp docker
docker --version

#--------------Install Git ----------------#
apt-get install -y git
git --version

#--------------Install docker-compose---------------#
curl -L https://github.com/docker/compose/releases/download/v2.24.0/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
docker-compose --version

#--------------Install AWS cli---------------#
apt-get install -y awscli
aws --version

#--------------Install Python---------------#
apt-get install -y python3
python3 --version

#--------------Install jq---------------#
apt-get install -y jq
jq --version

# #-------------- Install mysql client---------------#
# apt-get install -y mysql-client
# mysql --version

# #--------------Install CodeDeploy Agent---------------#
# apt-get install -y ruby-full
# apt-get install -y wget
# wget https://aws-codedeploy-us-east-1.s3.amazonaws.com/latest/install
# chmod +x ./install
# ./install auto
# systemctl start codedeploy-agent
# systemctl enable codedeploy-agent

