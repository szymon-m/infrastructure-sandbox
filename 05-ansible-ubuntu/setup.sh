#!/bin/bash
#

# turn down enp0s3 interface
ip link set enp0s3 down

# turn up enp0s8 interface
ip link set enp0s8 up

# set default route for enp0s8 interface
ip route add default via 192.168.1.1

# disable dhcp for enp0s3 interface
sed -e 's/dhcp4: true/dhcp4: false/g' -i /etc/netplan/50-cloud-init.yaml

# set correct hostname in /etc/hosts
HOST_IP=$(ip -f inet -j addr | jq '.[1].addr_info.[0].local' | sed 's/"//g')
HOSTNAME=$(hostname)
sed -e "s/192.168.1.101 ubuntu-2404-server.local.dev/${HOST_IP} ${HOSTNAME}/g" -i /etc/hosts
sed -e "s/127.0.1.1 ubuntu-2404-server/127.0.1.1 ${HOSTNAME}/g" -i /etc/hosts

