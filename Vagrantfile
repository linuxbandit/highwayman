Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.hostname = "blc.dev"
  config.vm.network :private_network, ip: "192.168.111.222"
  #config.vm.network :public_network, ip: "192.168.192.168"

  config.vm.provider :virtualbox do |vb|
    vb.customize [
      "modifyvm", :id,
      "--memory", "1024",
      "--name", "highwayman",
    ]
  end

  config.vm.define "highwayman"

  #Port forwarding
  #SSH from anywhere on the network (sshd)
  config.vm.network :forwarded_port, guest: 22, host: 2222, host_ip: "0.0.0.0", id: "ssh", auto_correct: true
  #everything through traefik
  config.vm.network :forwarded_port, guest: 80, host: 80, host_ip: "0.0.0.0", id: "http", auto_correct: true
  #traefik control
  config.vm.network :forwarded_port, guest: 8080, host: 8080, host_ip: "0.0.0.0", id: "traefik", auto_correct: true
  
  
  #sync of folders (only for dev purpose)
  #config.vm.synced_folder "./folder",              "/home/vagrant/folder"

  config.vm.provision "shell", path: "./vagrant-post-script/install_docker.sh", run: "always"
  #config.vm.provision "shell", path: "./install_docker_composer.sh", run: "always"

  config.vm.provision "docker" do |d|
    #d.pull_images "tianon/true"
    d.pull_images "traefik:1.3-alpine"
    d.pull_images "swaggerapi/swagger-editor"
    d.pull_images "portainer/portainer"
    #d.pull_images "rancher/server:stable"
    #d.pull_images "postgres:latest"
    #d.pull_images "fenglc/pgadmin4"
    #d.pull_images "node:7"
    #d.pull_images "nginx:alpine"
    #d.pull_images "mongo:latest"
    #d.build_image "/vagrant/app"
  end


  #provision docker orchestration (set to always run)
  config.vm.provision "shell", path: "vagrant-post-script/orchestrate_docker.sh", run: "always"
  
  config.vm.post_up_message = "Setup is complete, now open your browser to http://blc.dev (did you configure /etc/hosts?)"

end
