#!/bin/bash

# Suppress `dpkg-preconfigure` warning related to stdin for `apt-get install`
#  https://serverfault.com/a/670688
export DEBIAN_FRONTEND=noninteractive


# Install Docker CLI completion
#  https://ismailyenigul.medium.com/enable-docker-command-line-auto-completion-in-bash-on-centos-ubuntu-5f1ac999a8a6
echo "-----------------------------"
echo "Install Docker CLI completion"
echo "-----------------------------"
#  1. Install bash completion
apt-get install -y bash-completion
#  2. Place the Docker completion script in /etc/bash_completion.d/
curl -sS -L https://raw.githubusercontent.com/docker/docker-ce/master/components/cli/contrib/completion/bash/docker -o /etc/bash_completion.d/docker.sh


# Install Docker Color Output
#  https://github.com/devemio/docker-color-output
echo "---------------------------"
echo "Install Docker Color Output"
echo "---------------------------"
#  The latest version has to be downloaded from GitHub releases page
#  The downloaded file is already a binary file that does not require installation
curl -sS -L https://github.com/devemio/docker-color-output/releases/download/v2.2.0/docker-color-output-linux-amd64 -o /usr/bin/docker-color-output
chmod +x /usr/bin/docker-color-output
#  Add `docker-color-output` related aliases
#  As recommended by Ubuntu, our custom aliases will be added to ~/.bash_aliases
cat /vagrant/scripts/vagrant/docker-color-output-aliases.sh >> /home/vagrant/.bash_aliases