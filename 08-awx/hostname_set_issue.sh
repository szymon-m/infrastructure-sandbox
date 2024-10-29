#!/bin/bash

# SOLVED: need to add superuser privileges for vagrant user - otherwise it will fail to write to /etc/hosts
# `echo 'vagrant ALL=(ALL) NOPASSWD:ALL > /etc/sudoers.d/vagrant` 

# issue during this step of Vagrant up
# ==> master-01: Setting hostname...
# The following SSH command responded with a non-zero exit status.
# Vagrant assumes that this means the command failed!

#           grep -w 'master-01' /etc/hosts || {
#             for i in 1 2 3 4 5; do
# grep -w "127.0.${i}.1" /etc/hosts || {
#   echo "127.0.${i}.1 master-01 master-01" >> /etc/hosts
#   break
# }
#             done
#           }


# Stdout from the command:



# Stderr from the command:

grep -w 'master-01' /etc/hosts || {
    for i in 1 2 3 4 5; do
        grep -w "127.0.${i}.1" /etc/hosts || {
            echo "127.0.${i}.1 master-01 master-01" >> /etc/hosts
            break
        }
    done
}