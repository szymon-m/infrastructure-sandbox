#!/bin/bash
#

# turn on network interface required by Vagrant
ip link set enp0s3 up

# enable dhcp for enp0s3 interface
sed -e 's/dhcp4: true/dhcp4: false/g' -i /etc/netplan/50-cloud-init.yaml

# relanuch netplan with enabled dhcp in order to get ip for enp0s3 interface
netplan apply

