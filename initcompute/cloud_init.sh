#!/bin/bash
#########################################################################################################
#
# SCRIPT:            cloud_init.sh       
#
# cloud_init, to update the compute instance, and install and configure oSSH

echo 'cloud-init'


#yum update -y 

yum install -y curl openssh-server 
curl --retry 10 https://tims.oraclecloud.com/yum/install.sh | sudo bash

yum install -y ossh-server 

yum install -y nscd
systemctl enable nscd
systemctl start nscd 

getent passwd


yum install -y ossh-client 

eval `ssh-agent`

