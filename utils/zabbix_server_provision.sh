#!/bin/bash

#Installing and configuring MySQL DB (MariaDB)
sudo yum install mariadb mariadb-server -y
sudo /usr/bin/mysql_install_db --user=mysql
sudo systemctl start mariadb
mysql -uroot -e "create database zabbix character set utf8 collate utf8_bin;"
mysql -uroot -e "grant all privileges on zabbix.* to zabbix@localhost identified by 'zabbix';"

#Installing and configuring Zabbix Server
sudo yum install http://repo.zabbix.com/zabbix/3.2/rhel/7/x86_64/zabbix-release-3.2-1.el7.noarch.rpm -y
sudo yum install zabbix-server-mysql zabbix-web-mysql -y
sudo zcat /usr/share/doc/zabbix-server-mysql-*/create.sql.gz | mysql -uzabbix -p"zabbix" zabbix
sudo sed 's|# DBPassword=|DBPassword=zabbix|g' -i /etc/zabbix/zabbix_server.conf
sudo sed 's|# DBHost=localhost|DBHost=localhost|g' -i /etc/zabbix/zabbix_server.conf
sudo systemctl start zabbix-server

#Front-end Installation and Configuration
sudo yum install http://repo.zabbix.com/zabbix/3.2/rhel/7/x86_64/zabbix-release-3.2-1.el7.noarch.rpm -y
sudo yum install zabbix-web-mysql -y
sudo sed 's|# php_value date.timezone Europe/Riga|php_value date.timezone Europe/Minsk|g' -i /etc/httpd/conf.d/zabbix.conf
sudo systemctl start httpd

sudo cp conf/zabbix.conf.php /etc/zabbix/web/zabbix.conf.php