#!/bin/bash

# Constants
COWFILES_ARRAY=("default" "three-eyes" "bud-frogs" "sheep" "moofasa" "moose" "tux")
MOTD_FIGLET_HEADER="Vagrant VM"
MOTD_TMUX_COMMANDS="Attach to the tmux session using the following command:
$ tmux attach -t zookeeper-kafka"

# Suppress `dpkg-preconfigure` warning related to stdin for `apt-get install`
#  https://serverfault.com/a/670688
export DEBIAN_FRONTEND=noninteractive

# Install packages
apt-get install -y figlet
apt-get install -y lolcat
apt-get install -y cowsay

# Randomly choose a cowfile to be used with `cowsay`
#  Get array size
cowfilesArraySize=${#COWFILES_ARRAY[@]}
#  Get last array index
cowfilesArrayLastIndex=$((cowfilesArraySize-1))
#  Generate random value in the range [0, cowfilesArrayLastIndex]
cowfilesArrayRandomIndex=$(shuf -i 0-$cowfilesArrayLastIndex -n 1)
#  Get value from the array, using the random index
cowfile=${COWFILES_ARRAY[$cowfilesArrayRandomIndex]}
echo "$cowfile"

# Create a message of the day that will be displayed on login, storing it in /etc/motd
#  Welcome banner created with `figlet` and `lolcat`
figlet -t "$MOTD_FIGLET_HEADER" | # print header using `figlet`
  /usr/games/lolcat --spread 1.5 --force > /etc/motd # add rainbow coloring
#  Tmux commands for attaching to sessions created with `cowsay`
echo "$MOTD_TMUX_COMMANDS" |
  /usr/games/cowsay -n -f "$cowfile" | # print message using `cowsay` and the randomly selected cowfile
  perl -pe 's/\$ ([^>|\/\\]+)/\e[1;35m\$ \e[1;36m$1\e[0m/' >> /etc/motd # use regex to add coloring to tmux command (https://regex101.com/r/zy9w1L/1)

# Log message
echo "Message Of The Day (MOTD) updated with cowfile: $cowfile"
