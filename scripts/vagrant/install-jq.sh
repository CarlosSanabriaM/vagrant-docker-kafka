#!/bin/bash

# Suppress `dpkg-preconfigure` warning related to stdin for `apt-get install`
#  https://serverfault.com/a/670688
export DEBIAN_FRONTEND=noninteractive


# Install jq
apt-get install -y jq