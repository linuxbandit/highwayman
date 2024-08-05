machine_name = "blc.dev"
ip_address = "192.168.42.168"
vm_box = "bento/ubuntu-22.04"

Vagrant.configure("2") do |config|
  #Machine name for Vagrant, and machine type
  config.vm.define machine_name
  config.vm.box = vm_box

  #Machine name for virtualbox, and RAM size
  config.vm.provider :vmware_desktop do |vmw|
    vmw.vmx["memsize"] = "1024"
  end

  ## Folder configurations ##
  #sync of folders (commented because this specific one is already built-in)
  #config.vm.synced_folder "./folder",              "/home/vagrant/folder"

  ## Network configurations ##
  config.vm.hostname = machine_name
  config.vm.network :private_network, ip: ip_address
  #config.vm.network :public_network, ip: ip_address
  ## Port forwarding
  #If you want to SSH from anywhere on the network (sshd) uncomment this
  #config.vm.network :forwarded_port, guest: 22, host: 2222, host_ip: "0.0.0.0", id: "ssh", auto_correct: true
  #config.vm.network :forwarded_port, guest: 80, host: 80, host_ip: "0.0.0.0", id: "http", auto_correct: true
  #config.vm.network :forwarded_port, guest: 443, host: 443, host_ip: "0.0.0.0", id: "https", auto_correct: true

  ## Provisioning scripts ##
  #make it work also when windows messes up the line ending
  ###COMMENTED BECAUSE BREAKS VMWARE
  #config.vm.provision "shell", inline: "apt-get install dos2unix -qq -y; cd /vagrant && dos2unix *.sh; dos2unix scripts-vagrant_provision/*.sh"

  #nice-to-have prompt and completion
  config.vm.provision "shell", inline: "dos2unix /vagrant/scripts-vagrant_provision/bashrc; cat /vagrant/scripts-vagrant_provision/bashrc > /home/vagrant/.bashrc"

  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "scripts-vagrant_provision/provision.yml"
    ansible.compatibility_mode = "2.0"
    ansible.extra_vars = "scripts-vagrant_provision/local.yml"
    #ansible.tags = "docker"
  end

  config.vm.provision "docker" do |d|
    d.pull_images "tianon/true"
    d.pull_images "swaggerapi/swagger-editor"
    d.pull_images "traefik:v2.11.0"
    #d.pull_images "postgres:latest"
    #d.pull_images "fenglc/pgadmin4"
    #d.pull_images "nginx:alpine"
    #d.build_image "/vagrant/app"
  end

  #provision docker orchestration (set to always run)
  config.vm.provision "shell", path: "scripts-vagrant_provision/run-traefik.sh", run: "always"

  config.vm.post_up_message = "Setup is complete, open your browser to http://#{machine_name} (did you configure /etc/hosts via start.sh, or manually?)"

  ## Deprovisioning scripts ##
  # config.trigger.before :destroy do |trigger|
  #   trigger.warn = "Removing .init to avoid Docker network mismatch"
  #   trigger.run_remote = { inline: "rm /vagrant/.init 2>/dev/null || echo 'file already gone'" }
  # end

end
