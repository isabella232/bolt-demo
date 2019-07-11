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
      inline: <<~INSTALL
        yum install -y puppet-bolt.rpm

        printf '#{hosts_file}' >> /etc/hosts
      INSTALL
    else
      bolt.vm.provision "shell", privileged: true,
      inline: <<~INSTALL
        rpm -Uvh https://yum.puppet.com/puppet6-release-el-7.noarch.rpm
        yum install -y puppet-bolt git

        printf '#{hosts_file}' >> /etc/hosts
      INSTALL
    end

    bolt.vm.provision "shell", privileged: false, inline: "/vagrant/install_ruby.sh"
    bolt.vm.provision "shell", privileged: false, inline: <<~CODE
      cp -r /vagrant/project_dir ~/Boltdir
      cp /vagrant/demo.rb ~/
      cd ~/Boltdir
      bolt puppetfile install
    CODE

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
