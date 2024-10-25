Vagrant.configure("2") do |config| 


  SYNCED_FOLDER_HOST = "website/"
  SYNCED_FOLDER_GUEST = "/var/www/html"
  BASE_INT_NETWORK = "10.10.20"
  BASE_HOST_ONLY_NETWORK = "192.168.56"
  HOST_ONLY_ADAPTER = "VirtualBox Host-Only Ethernet Adapter"



  config.vm.define "web" do |web_config|
    web_config.vm.box = "ubuntu/jammy64"
    web_config.vm.hostname = "web.m340"
    web_config.vm.hostname = "web.m340"
    web_config.vm.provider "virtualbox" do |vb|
      vb.name = "web.m340"
      vb.memory = "2048"
      vb.cpus = 2
    end 

    web_config.vm.synced_folder SYNCED_FOLDER_HOST, SYNCED_FOLDER_GUEST, create: true


    web_config.vm.network "private_network", ip: "#{BASE_INT_NETWORK}.10", virtualbox__intnet: true
    web_config.vm.network "private_network", ip: "#{BASE_HOST_ONLY_NETWORK}.10",  name: HOST_ONLY_ADAPTER
    web_config.ssh.insert_key = false

    if Vagrant.has_plugin?("vagrant-proxyconf") && false
      web_config.proxy.http = "http://10.20.0.1:8080"
      web_config.proxy.https = "http://10.20.0.1:8080"
      web_config.proxy.no_proxy = "localhost,127.0.0.1"
    end

    web_config.vm.provision "shell", path: "provisioning/web_provision.sh"
  end
  config.vm.define "db" do |db_config|
    db_config.vm.box = "ubuntu/jammy64"

    db_config.vm.hostname = "db.m340"
    db_config.vm.provider "virtualbox" do |vb|
      vb.name = "db.m340"
      vb.memory = "2048"
      vb.cpus = 2
    end
    
    db_config.vm.network "private_network", ip: "#{BASE_INT_NETWORK}.11", virtualbox__intnet: true
    db_config.ssh.insert_key = false

    if Vagrant.has_plugin?("vagrant-proxyconf") && false
      db_config.proxy.http = "http://10.20.0.1:8080"
      db_config.proxy.https = "http://10.20.0.1:8080"
      db_config.proxy.no_proxy = "localhost,127.0.0.1"
    end
    db_config.vm.provision "shell", path: "provisioning/db_provision.sh"
  end
end
