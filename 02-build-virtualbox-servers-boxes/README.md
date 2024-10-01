## creating ubuntu 24-04 server image

1. download Ubuntu 24.04 server
2. install Virtualbox 
3. start new VM as ubuntu-24-04-server 
    - local.dev (domain) 
    - user: atos password: student (instead of 'vboxuser'/'changeme' guest main user)
    - first network interface as NAT (in order to get access via mobaxtrerm swith the first interface to Bridged type - and check IP addres with 'ip a' on enp0s3 interface, at the end of box preparation (before packing it with vagrant package command - you need to assure that on first interface is network in type NAT - thats the vagrant requirement for accessing VM with such interface and vagrant)

4. after installation restart VM and login as atos (password : student) - then switch to root using : `sudo -i` - password: student

    - create sudoers file with `echo 'vagrant ALL=(ALL) NOPASSWD:ALL > /etc/sudoers.d/vagrant` 

5. configure vagrant user:

    - `useradd vagrant` (password vagrant)
    - switch to vagrant user  `su - vagrant`
    - create .ssh directory in home directory `mkdir ~/.ssh`
    - create authorized_keys file in ~/.ssh  `vi ~/.ssh/authorized_keys`
    - copy and paste public keys (vagrant.pub from https://github.com/hashicorp/vagrant/tree/main/keys) into opened authorized_keys - then save file


6. install VMBox Guest additions: follow this guide https://developer.hashicorp.com/vagrant/docs/boxes/base 
7. finally - save the state in virtualbox 
8. make sure that:

    - vm got two network interfaces: 
        - enp0s3 -> with NAT type 
        - enp0s8 -> with Briged type - assure that listening type is 'allowed to all'

9. launch in command line:

    `vagrant package --base ubuntu-24-04-server --output ubuntu-24-04-server.box`

6. add box into Virtualbox for use with Vagrantfile :

    `vagrant box add --name ubuntu-24-04-server .\ubuntu-24-04-server.box` 

7. start vagrant

    `vagrant up --provider=virtualbox`


8. if works correct then - clone *ubuntu-24-04-server* box in virtualbox as a *ubuntu-24-04-server-k8s* 
9. follow guidline of configuring vm for kubernetes :

    - remove swap 
    - add neccessary kernel modules : overlay, br_netfilter
    - add sysctl flags : net.ipv4.ip_forward = 1
    - install container runtime :  apt-get install containerd - and set confiruation for SystemD.cgroupfs driver for 'true'
    - add keys and repostiories for kubelet, kubectl, kubeadm
    - install kubelet, kubectl, kubeadm - and mark them hold - to not accidentaly upgrade them
    - install keepalived and haproxy - but disable services for now
    - copy configure.sh file from 04-k8s-ha-cluster directory into /root folder    

10. make sure that:

    - vm got two network interfaces:
        - enp0s3 -> with NAT type
        - enp0s8 -> with Briged type - assure that listening type is 'allowed to all'
    
    - using VMs with Vagrant :

        - `masternode.vm.network "public_network", ip: "192.168.1.10#{i}", bridge: "Intel(R) Ethernet Connection (11) I219-LM"`
        - `workernode.vm.network "public_network", ip: "192.168.1.20#{i}", bridge: "Intel(R) Ethernet Connection (11) I219-LM"`


        - in Vagrantfile: set "public networks"  bridging to given host's Ethernet network (in my case Intel® Ethernet Connection (11) I219-LM
        - start in console :   vagrant up --provider=virtualbox
        - log into VM and set interface used by Vagrant (enp0s3) to "DOWN" : ip link set enp0s3 down
        - log into VM and set add default gateway for interface (enp0s8) : ip route add default via 192.168.1.1 dev enp0s8
        - check DNS resolution (unlink /etc/resolved.conf if needed (by removing this file) and add new file /etc/resolved.conf with : nameserver 8.8.8.8 (or) nameserver 192.168.1.1
        - ping google.com to check whether external connection is available
            
11. save state of vm - rerun - and turn down VM - and - export package with :

    `vagrant package --base ubuntu-24-04-server-k8s --output ubuntu-24-04-server-k8s.box`

11. add box into Virtualbox for use with Vagrantfile :

    `vagrant box add --name ubuntu-24-04-server-k8s .\ubuntu-24-04-server-k8s.box` 

12. start 

    `vagrant up --provider=virtualbox`