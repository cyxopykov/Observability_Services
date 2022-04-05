#!/bin/bash

#Zabbix Agent Installation

sudo yum install http://repo.zabbix.com/zabbix/3.2/rhel/7/x86_64/zabbix-release-3.2-1.el7.noarch.rpm -y
sudo yum install zabbix-agent -y
sudo systemctl start zabbix-agent

sudo sed 's|Server=127.0.0.1|Server=192.168.80.4|g' -i /etc/zabbix/zabbix_agentd.conf
sudo sed 's|# ListenPort=10050|ListenPort=10050|g' -i /etc/zabbix/zabbix_agentd.conf
sudo sed 's|# ListenIP=0.0.0.0|ListenIP=0.0.0.0|g' -i /etc/zabbix/zabbix_agentd.conf
sudo sed 's|# StartAgents=3|StartAgents=3|g' -i /etc/zabbix/zabbix_agentd.conf

sudo sed 's|ServerActive=127.0.0.1|ServerActive=192.168.80.4:10051|g' -i /etc/zabbix/zabbix_agentd.conf
sudo sed 's|# HostnameItem=system.hostname|HostnameItem=system.hostname|g' -i /etc/zabbix/zabbix_agentd.conf
sudo sed 's|# HostnameItem=system.hostname|HostnameItem=system.hostname|g' -i /etc/zabbix/zabbix_agentd.conf

sudo systemctl restart zabbix-agent




#Deployng TOMCAT
sudo yum install -y yum-utils
sudo yum-config-manager     --add-repo     https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install docker-ce docker-ce-cli containerd.io -y
sudo systemctl start docker
sudo docker build -t mytomcat:1 -f .
sudo mkdir -p tomcat/logs
sudo docker run -d -p 80:8080 -v /home/vagrant/tomcat/logs:/usr/local/tomcat/logs mytomcat:1




