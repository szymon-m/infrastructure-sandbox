#!/bin/bash

move_configuration_files() {
    if [ -e /home/vagrant/haproxy.conf ] && [ -e /home/vagrant/keepalived.conf ] && [ -e /home/vagrant/check_apiserver.sh ]; then
            echo "[ move Vagrant configuration files ] $(ls -la /home/vagrant)"
            mv /home/vagrant/haproxy.conf /etc/haproxy/haproxy.conf
            mv /home/vagrant/keepalived.conf /etc/keepalived/keepalived.conf
            mv /home/vagrant/check_apiserver.sh /etc/keepalived/check_apiserver.sh
            chown root:root /etc/haproxy/haproxy.conf
            chown root:root /etc/keepalived/keepalived.conf
            chown root:root /etc/keepalived/check_apiserver.sh
            chmod +x /etc/keepalived/check_apiserver.sh
            echo "[ move Vagrant configuration files ] configuration files moved"
    else
            echo "[ move Vagrant configuration files ] configuration files not found in vagrant user's home directory"
    fi
}

set_ip() {
    ip addr del 10.0.2.15/24 dev enp0s3
    SERVER_IP=$(ip addr show enp0s8 | grep "192.168." | cut -d "." -f4 | cut -d "/" -f1)
    IP_GREP_CHECK=$(echo $SERVER_IP | grep -E "^[0-9]{2,3}$") # if SERVER_IP got only 2 or 3 digits
    if [ -z $IP_GREP_CHECK ]; then  # if zero (empty)
        echo "[IP set] IP address cannot be set. Found (no or two or more) addresses in 192.168.0.0 subnet: $SERVER_IP"        
    else
        HOST_IP="10.0.2.$SERVER_IP"
        ip addr add "$HOST_IP/24" dev enp0s3
        echo "[IP set] IP addres set to enp0s3 interface : $HOST_IP/24"
    fi
    ip route add default via 10.0.2.2 dev enp0s3
    echo "[IP set] default route set on 10.0.2.2"
}


HOSTNAME=$(hostname | cut -d '-' -f1)
case $HOSTNAME in

    lb)
        echo "[load balancer] setting IP for loadbalancer" ;
        set_ip
        echo "[load balancer] moving configuration files from vagrant user's home directory"
        move_configuration_files ;
        if [ -e /etc/keepalived/keepalived.conf ] && [ -e /etc/keepalived/check_apiserver.sh ]; then
                systemctl restart keepalived ;
                echo "[load balancer] keepalived service restarted" ;
        else
                echo "[load balancer] Service : keepalived - not started. Files: /etc/keepalived/keepalived.conf and /etc/keepalived/check_apiserver.sh not found in path"
        fi
        if [ -e /etc/haproxy/haproxy.cfg ]; then
                systemctl restart haproxy ;
                echo "[load balancer] haproxy service restarted" ;
        else
                echo "[load balancer] Service: haproxy - not started. File: /etc/haproxy/haproxy.cfg not found in path"
        fi
    ;;

    master)
        set_ip
    ;;

    worker)
        set_ip
    ;;

    ansible)
        set_ip
    ;;

    vm)
        set_ip
    ;;
esac