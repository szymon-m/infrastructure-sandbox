#!/bin/bash

main() {
        venvPath="$HOME/venv-ansible"
        if [[ ! -e $venvPath ]]
        then
                echo "ERROR: No Virtual environment available"
                exit 1
        fi

        source "$venvPath/bin/activate"

        # if interactive session then print information
        if [[ $- == *i* ]]
        then
                echo "Virtual Enviroment for Python 3.11 and Ansible 10.4 activated"
        fi

        if [[ $CONFIGURED -eq 0 ]];  # global env variable configured in .bashrc
        then
            # setting networks 
            # echo 'Setting networks'   # echos need to be removed -> 
            sudo nmcli device down enp0s3
            sudo nmcli connection modify System\ enp0s8 connection.id enp0s8

            sudo ip route add default via 192.168.1.1 dev enp0s8

            sudo chmod 0666 /etc/hosts
            sudo chmod 0666 /etc/resolv.conf

            sudo sed -e 's/nameserver 10.0.2.3/nameserver 192.168.1.1/g' -i /etc/resolv.conf
            sudo sed -e 's/search home//g' -i /etc/resolv.conf

            echo -e "nameserver 192.168.1.1" >> /etc/resolv.conf

            sudo sed -e 's/127.0.1.1.*//g' -i /etc/hosts

            if [[ $SPECTRUM -eq 1 ]];
            then
                echo -e "192.168.1.101 ansible-01\n192.168.1.201 ls-01\n192.168.1.202 ls-02\n192.168.1.211 lsb-01\n192.168.1.212 lsb-02\n192.168.1.51 mls-01\n192.168.1.52 mls-02" >> /etc/hosts
            else
                echo -e "192.168.1.101 ansible-01\n192.168.1.201 vm-01\n192.168.1.202 vm-02\n192.168.1.203 vm-03\n192.168.1.204 vm-04" >> /etc/hosts
            fi

            sudo chmod 0644 /etc/hosts
            sudo chmod 0644 /etc/resolv.conf
            sed -e 's/export CONFIGURED=0/export CONFIGURED=1/g' -i ~/.bashrc
        # else
        #     echo 'Network configurations already done!'
        fi

}

main "$@"
