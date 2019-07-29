# -*- mode: ruby -*-
# vi: set ft=ruby :

TARGET_COUNT = 2

Vagrant.configure("2") do |config|

  hosts = { 'bolt' => '10.0.0.200' }
  targets = []
  TARGET_COUNT.times do |i|
    tn = "target#{i}"
    hosts[tn] = "10.0.0.#{100 + i}"
    targets << tn
  end
  packages = "yum-utils device-mapper-persistent-data lvm2 wget unzip git"

  hosts_file = hosts.map { |k, v| "#{v} #{k}" }.join('\n')

  SSH_CONFIG = <<~SSH
    cp -r /vagrant/ssh/* ~/.ssh
    cat ~/.ssh/id_bolt.pub >> ~/.ssh/authorized_keys
  SSH

  config.vm.define "bolt", primary: true do |bolt|
    bolt.vm.box = "centos/7"
    bolt.vm.hostname = "bolt"

    bolt.vm.network "private_network", ip: "10.0.0.200"

    if ENV['BOLT_PACKAGE']
      bolt.vm.provision "file", source: ENV['BOLT_PACKAGE'], destination: "~/puppet-bolt.rpm"

      bolt.vm.provision "shell", privileged: true,
      inline: <<~INSTALL_BOLT
        yum install -y puppet-bolt.rpm #{packages}

        printf '#{hosts_file}' >> /etc/hosts
      INSTALL_BOLT
    else
      bolt.vm.provision "shell", privileged: true,
      inline: <<~INSTALL_BOLT
        rpm -Uvh https://yum.puppet.com/puppet6-release-el-7.noarch.rpm
        yum install -y puppet-bolt #{packages}

        printf '#{hosts_file}' >> /etc/hosts
      INSTALL_BOLT
    end

    ### Install Docker, Go, Terraform, and Terraform Docker provider
    bolt.vm.provision "shell", privileged: true, inline: "/vagrant/resources/install_terraform.sh"

    ### Install Ruby
    bolt.vm.provision "shell", privileged: false, inline: "/vagrant/resources/install_ruby.sh"

    ### Install demos
    bolt.vm.provision "file", source: "./project_dir", destination: "/home/vagrant/Boltdir"
    bolt.vm.provision "file", source: "./demos", destination: "~/demos"
    bolt.vm.provision "file", source: "./executor.rb", destination: "~/executor.rb"
    bolt.vm.provision "file", source: "./demo_prompt.rb", destination: "~/demo_prompt.rb"

    ### Install Puppet modules
    bolt.vm.provision "shell", privileged: false, inline: <<~INSTALL_PUPPETFILE
      cd ~/Boltdir
      bolt puppetfile install
      terraform init
      terraform apply -auto-approve
    INSTALL_PUPPETFILE

    bolt.vm.provision "shell", privileged: false, inline: SSH_CONFIG
  end

  targets.each do |target_name|
    config.vm.define(target_name) do |target|
      target.vm.box = "centos/7"
      target.vm.hostname = target_name
      target.vm.network "private_network", ip: hosts[target_name]

      target.vm.provision "shell", privileged: true, inline: "yum install -y httpd"
      target.vm.provision "shell", privileged: true, inline: "echo 'Timeout 300' >> /etc/httpd/conf/httpd.conf"
      target.vm.provision "shell", privileged: true, inline: "printf '#{hosts_file}' >> /etc/hosts"
      target.vm.provision "shell", privileged: false, inline: SSH_CONFIG
    end
  end
end
