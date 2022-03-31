#!/bin/bash

sudo yum update -y

# OpenLDAP Server Installation
sudo yum install openldap openldap-servers openldap-clients -y
sudo systemctl start slapd
sudo systemctl enable slapd
sudo systemctl status slapd

ADMIN_PASS=$(cat ldif/admin_pass)
USER_PASS=$(cat ldif/user_pass)
PASSWORD=$(slappasswd -s ${ADMIN_PASS})
PASSWORD2=$(slappasswd -s ${USER_PASS})

#Create an LDIF file (ldaprootpasswd.ldif) which is used to add an entry to the LDAP directory
sed -i "s/PASS/${PASSWORD}/g" ldif/ldaprootpasswd.ldif
sudo ldapadd -Y EXTERNAL -H ldapi:/// -f ldif/ldaprootpasswd.ldif

#LDAP Database
sudo cp /usr/share/openldap-servers/DB_CONFIG.example /var/lib/ldap/DB_CONFIG
sudo chown -R ldap:ldap /var/lib/ldap/DB_CONFIG
sudo systemctl restart slapd
sudo ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/openldap/schema/cosine.ldif
sudo ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/openldap/schema/nis.ldif
sudo ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/openldap/schema/inetorgperson.ldif

#Add Domain Configuration
sed -i "s/PASS/${PASSWORD}/g" ldif/ldapdomain.ldif
sudo ldapmodify -Y EXTERNAL -H ldapi:/// -f ldif/ldapdomain.ldif

#Add Entries to OpenLDAP Database
sudo ldapadd -x -D cn=Manager,dc=devopsldab,dc=com -w ${ADMIN_PASS} -f ldif/baseldapdomain.ldif

#Create the definitions for a LDAP group
sudo ldapadd -x -D "cn=Manager,dc=devopsldab,dc=com" -w ${ADMIN_PASS} -f ldif/ldapgroup.ldif

#Create another LDIF file called ldapuser.ldif and add the definitions for user tecmint.
sed -i "s/USER_PASS/${PASSWORD2}/g" ldif/ldapuser.ldif
ldapadd -x -D cn=Manager,dc=devopsldab,dc=com -w ${ADMIN_PASS} -f ldif/ldapuser.ldif

#Installation of phpldapadmin
sudo yum --enablerepo=epel -y install phpldapadmin
sudo sed -i '397 s;// $servers;$servers;' /etc/phpldapadmin/config.php
sudo sed -i '398 s;$servers->setValue;// $servers->setValue;' /etc/phpldapadmin/config.php
sudo sed -i ' s;Require local;Require all granted;' /etc/httpd/conf.d/phpldapadmin.conf 
sudo sed -i ' s;Allow from 127.0.0.1;Allow from 0.0.0.0;' /etc/httpd/conf.d/phpldapadmin.conf 
sudo systemctl restart httpd


