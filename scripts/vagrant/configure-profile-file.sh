#!/bin/bash

# This script configures the contents of the ~/.profile file

# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login exists.

# Automatically chdir to /vagrant directory upon `vagrant ssh`
cat <<EOF >> /home/vagrant/.profile

# Automatically chdir to /vagrant directory upon \`vagrant ssh\`
cd /vagrant
EOF