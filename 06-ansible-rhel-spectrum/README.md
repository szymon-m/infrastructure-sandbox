# ansible-rhel-86 - Ansible <-> Spectrum DEV environment

| **Role**         | **FQDN**                   | **IP**           | **OS**         | **RAM** | **CPU** |
|------------------|----------------------------|------------------|----------------|---------|---------|
| Control Node     | ansible-01                 | 192.168.1.101    | RHEL 8.6       | 4G      | 2       |
| MLS              | mls-01                     | 192.168.1.51     | RHEL 8.6       | 2G      | 2       |
| MLS              | mls-02                     | 192.168.1.52     | RHEL 8.6       | 2G      | 2       |
| Landscape        | ls-01                      | 192.168.1.201    | RHEL 8.6       | 2G      | 2       |
| Landscape        | ls-02                      | 192.168.1.202    | RHEL 8.6       | 2G      | 2       |
| Backup Landscape | lsb-01                     | 192.168.1.211    | RHEL 8.6       | 2G      | 2       |
| Backup Landscape | lsb-02                     | 192.168.1.212    | RHEL 8.6       | 2G      | 2       |

## Prepare rhel-86-server-ansible Virtual box:

1. use RHEL server image with version 8.6
2. install on VirutalBox, with user: atos  / password: student - as an administrative user  . Use "server without GUI" packages sets 
3. network setup:

    - enp0s3 -> disabled (default addresses 10.0.2.15)  - > NAT type interface
    - enp0s8 -> enabled (set manualy addres from 192.168.1.0/24 network , gateway 192.168.1.1, dns 192.168.1.1) - > Bridge type interface (bridging to host Ethernet network - possibly need to adjust IP ranges)

    - turn off enp0s3
        `nmcli conn down enp0s3`
    - set IP address
        `nmcli conn modify enp0s8 -ipv4.addresses 192.168.1.154/24` - for addresses cleanup

        `nmcli conn modify enp0s8 ipv4.addresses 192.168.1.101/24 ipv4.gateway 192.168.1.1 ipv4.dns 192.168.1.1 ipv4.method manual` - chooose correct IP address

        restart connection :

        `nmcli conn down enp0s8`

        `nmcli conn up enp0s8`

4. install 

    - python3.11 

        `dnf install python3.11`

        `dnf install python-3.11-pip`

        `dnf install gcc gcc-c++ kernel-devel make`  -> used by VMBox Guest Additions
        
        (or simply)

        `dnf install kernel-headers-$(uname -r) kernel-devel-$(uname -r)` - use uname -r to get correct kernel version used by your RHEL

5. create user `ansible`  set password to ansible , add full sudo access, and generate ssh key

    `useradd ansible`

    `passwd ansible` - ansible/ansible

    `echo 'ansible ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/ansible`

    as ansible user (swith from root with : `su - ansible`)
    `ssh-keygen -t rsa -b 2048`

6. after installation restart VM and login as atos (password : student) - then switch to root using : `sudo -i` - password: student

    - create sudoers file with `echo 'vagrant ALL=(ALL) NOPASSWD:ALL > /etc/sudoers.d/vagrant` 

7. configure vagrant user:

    - `useradd vagrant` (password vagrant)
    - switch to vagrant user  `su - vagrant`
    - create .ssh directory in home directory `mkdir ~/.ssh`  (!! IMPORTANT .ssh dir need to have 0700 mode )
    - create authorized_keys file in ~/.ssh  `vi ~/.ssh/authorized_keys`  (!! IMPORTANT .ssh/authorized_keys need to have 0600 mode )
    - copy and paste public keys (vagrant.pub from https://github.com/hashicorp/vagrant/tree/main/keys) into opened authorized_keys - then save file
