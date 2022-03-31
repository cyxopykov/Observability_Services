# Observability Services
```shell
# -*- mode: ruby -*-
# vi: set ft=ruby :
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.ssh.insert_key = false
  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", "512"]
  end

  # LDAP server 
  config.vm.define "ldap_server" do |ldap|
    ldap.vm.hostname = "server"
    ldap.vm.box = "geerlingguy/centos7"
    ldap.vm.network :private_network, ip: "192.168.80.4"
    ldap.vm.provision "file", source: "utils/ldif", destination: "$HOME/ldif"
    ldap.vm.provision "shell", path: "utils/server_provision.sh", privileged: false	
  end

  # LDAP client
  config.vm.define "ldap_client" do |ldap|
    ldap.vm.hostname = "client"
    ldap.vm.box = "geerlingguy/centos7"
    ldap.vm.network :private_network, ip: "192.168.80.5"
    ldap.vm.provision "shell", path: "utils/client_provision.sh", privileged: false
  end

end
```

![This is an image](phpLDAPadmin.png)

![This is an image](client.png)
