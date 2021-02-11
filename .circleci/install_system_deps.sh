#!/bin/bash -eo pipefail

apt-get update
apt-get install --no-install-recommends -y wget curl
apt-get clean
wget --version
curl --version
