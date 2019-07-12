#!/usr/bin/env bash

# Install Docker
if ! [ -x "$(command -v docker)" ]; then
  sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
  sudo yum install -y docker-ce
  sudo usermod -aG docker vagrant
  sudo systemctl enable docker.service
  #sudo systemctl start docker.service
  sudo dockerd -H unix:///var/run/docker.sock -H tcp://0.0.0.0:2375 &>/dev/null &
fi

# Install Terraform
if ! [ -x "$(command -v terraform)" ]; then
  sudo unzip /vagrant/resources/terraform_0.12.4_linux_amd64.zip -d /usr/local/bin/
fi

# Install Docker Provider
if ![ -d "/home/vagrant/go/src/github.com/terraform-providers" ]; then
  mkdir -p /home/vagrant/go/src/github.com/terraform-providers
  cd /home/vagrant/go/src/github.com/terraform-providers
  git clone https://github.com/terraform-providers/terraform-provider-docker
  make build
fi
