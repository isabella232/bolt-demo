#!/bin/bash
curl -sSL https://get.rvm.io | bash
echo '[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm" # Load RVM function' >> ~/.bash_profile
source ~/.bash_profile
rvm autolibs enable
rvm install 2.5 
rvm use 2.5 --default
echo "install: --no-rdoc --no-ri" >> ~/.gemrc
echo "update: --no-rdoc --no-ri" >> ~/.gemrc
gem install -g /vagrant/Gemfile
