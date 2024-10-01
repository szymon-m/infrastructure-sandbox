#!/bin/bash

main() {
    venvPath="$HOME/venv-ansible-10-4"
    if [[ ! -e $venvPath ]]
    then
        echo "ERROR: Virtual Environment directory not found: $venvPath"
        exit 1
    fi

    source "$venvPath/bin/activate"

    # if interactive session then print information
    if [[ $- == *i* ]]
    then
        echo "Virtual Environment of Python 3.12 and Ansible 10.4 activated"
    fi

    # set correct IPs
    sudo ./configure.sh

    HOSTNAME=$(hostname | cut -d '-' -f1)
    if [[ $HOSTNAME == 'ansible']]
    then
        # send Ansible control node (ansible-01) ssh public key to all vm nodes (vm-01, vm-02, vm-03)
        ansible vms -m authorized_key -a "user='ansible' state='present' key='{{ lookup('file','.ssh/id_rsa.pub')}}'" -i hosts 
    fi

    
}

main "$@"
