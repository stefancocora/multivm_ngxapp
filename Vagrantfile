# -*- mode: ruby -*-
# vi: set ft=ruby :

# defaults targeting hypervisor and hypervisor host
ENV['VAGRANT_DEFAULT_PROVIDER'] = 'virtualbox'
ENV['LIBVIRT_ENGINE'] = 'localhost'

# Specify minimum Vagrant version and Vagrant API version
Vagrant.require_version '>= 1.8.0'
VAGRANTFILE_API_VERSION = '2'

# Create and configure the VMs
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # Always use Vagrant's default insecure key
  config.ssh.insert_key = false

  config.vm.define "vmhost" do |vmhost|
    vmhost.vm.box_check_update = false
    vmhost.vm.hostname = "vmhost"

    if ENV['OSTYPE'] == "fedora"
    then
      vmhost.vm.box = "fedora/25-cloud-base"
    elsif ENV['OSTYPE'] == "ubuntu"
    then
      vmhost.vm.box = "bento/ubuntu-16.04"
    elsif ENV['OSTYPE'] == "debian"
    then
      vmhost.vm.box = "debian/jessie64"
    else
      vmhost.vm.box = "centos/7"
    end

    vmhost.vm.network "private_network", :ip => '192.168.100.20'
    vmhost.vm.network "forwarded_port", guest: 18080, host: 18080, protocol: "tcp"

    # Configure CPU & RAM per settings in machines.yml (VirtualBox)
    vmhost.vm.provider 'virtualbox' do |vb, override|
        vb.memory = 1024
        vb.cpus = 1
    end

    vmhost.vm.provision "shell" do |sh|
      sh.path = "scripts/detectos.sh"
    end

    vmhost.vm.provision "ansible" do |ansible|
      ansible.playbook = "ansible/playbook.yml"
    end

  end

end # Vagrant configuration
