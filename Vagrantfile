# -*- mode: ruby -*-
# vi: set ft=ruby :
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.ssh.insert_key = false
  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", "512"]
  end

  # ZABBIX server 
  config.vm.define "zabbix_server" do |zabbix|
    zabbix.vm.hostname = "server"
    zabbix.vm.box = "geerlingguy/centos7"
    zabbix.vm.network :private_network, ip: "192.168.80.4"
    zabbix.vm.provision "file", source: "utils/conf", destination: "$HOME/conf"
    zabbix.vm.provision "shell", path: "utils/zabbix_server_provision.sh", privileged: false	
  end

  # ZABBIX client
  config.vm.define "zabbix_agent" do |zabbix|
    zabbix.vm.hostname = "agent"
    zabbix.vm.box = "geerlingguy/centos7"
    zabbix.vm.network :private_network, ip: "192.168.80.5"
    zabbix.vm.provision "shell", path: "utils/zabbix_agent_provision.sh", privileged: false
  end

end
