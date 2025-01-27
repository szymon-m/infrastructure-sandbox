#!/bin/bash

nmcli device down enp0s3
nmcli connection modify System\ enp0s8 connection.id enp0s8
ip route add default via 192.168.1.1 dev enp0s8
echo -e "nameserver 192.168.1.1" >> /etc/resolv.conf