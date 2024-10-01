## using Vagrant file for provisioning HA Kubernetes cluster infrastructure

| **Role**         | **FQDN**                   | **IP**           | **OS**         | **RAM** | **CPU** |
|------------------|----------------------------|------------------|----------------|---------|---------|
| Load Balancer    | lb-01                      | 192.168.1.51     | Ubuntu 24.04   | 2G      | 2       |
| Load Balancer    | lb-02                      | 192.168.1.52     | Ubuntu 24.04   | 2G      | 2       |
| Master           | master-01                  | 192.168.1.101    | Ubuntu 24.04   | 2G      | 2       |
| Master           | master-02                  | 192.168.1.102    | Ubuntu 24.04   | 2G      | 2       |
| Master           | master-03                  | 192.168.1.103    | Ubuntu 24.04   | 2G      | 2       |
| Worker           | worker-01                  | 192.168.1.201    | Ubuntu 24.04   | 2G      | 2       |


0. I prepared custom Vagrant box named: ubuntu-2404-server-custom.box

    1. download ubuntu-2404-live-server from Ubuntu web site
    2. launch this image in VirtualBox  - naming it as ubuntu-2404-server-k8s-conf
    3. configure it to operate with k8s and copy configure.sh file into /root/configure.sh
    4. stop VM
    5. launch in command line:

        `vagrant package --base ubuntu-2404-server-k8s-conf --output ubuntu-2404-server-k8s-conf.box`

    6. add box into Virtualbox:

        `vagrant box add --name ubuntu-2404-server-k8s-conf .\ubuntu-2404-server-k8s-conf.box` 


    ubuntu-2404-server-k8s-conf consists of:
    - configured kernel modules, sysctl     
    - installed containerd CRI
    - configured pkg.k8s.io repository
    - installed kubelet, kubectl, kubeadm with version v1.30.0 and marked as hold
    - installed haproxy
    - installed keepalived
    - /root/configure.sh script
    

1. in CLI type:

     `vagrant up --provider=virtualbox `

2. setup haproxy and keepalived _> two config scripts and one bash shell script
3. ip addresses on masters and workers need to be chanhes:

    24.09.24 -> launch /root/configure.sh    - in order to change ip address on enp0s3 / and copy service config files for keepalived, haproxy


    (you can copy and use script - configure.sh - it was not possible to pass bash functions through vagrant vm.config provision shell ) 
    (i was able to copy whith vagrant user config files from ../etc directory - for HAProxy and keepalived)

    `ip addr del 10.0.2.15/24 dev enp0s3`
    `ip addr add 10.0.2.16/24 dev enp0s3`  (51,52 for lb, 101,102,103 for masters, 201 for worker)
    `ip route add default via 10.0.2.2`

3a. (01.10.2024) -  used public network briged to hosts's NIC (network 192.168.1.0/24)
    - need to disable 1st network interface enp0s3 (ip link set enp0s3 down)
    - enable (ip link set enp0s8 up) and add ip address to 2nd network interface enp0s8 (ip address add 192.168.1.x/24 dev enp0s8)
    - add default route to enp0s8 -> ip route add default via 192.168.1.1 dev enp0s8
    - check /etc/hosts
    - check /etc/resolved.conf

    -- check Vagrant file and setup.sh / destroy.sh scripts



4. on master-01 : 


    (01.10.2024) - > no need to use --apiserver-advertise-address  - check 3a.

    `kubeadm init --control-plane-endpoint="192.168.1.100:6443" --upload-certs --apiserver-advertise-address=192.168.1.101 --pod-network-cidr=10.100.0.0/16 --v=5 `


5. kubeadm join control planes and worker

     join cluster plane (master-02 and master-03) to control nodes : (possible string like - hashes / tokens / cert may differ) :

     `  kubeadm join 192.168.1.100:6443 --token 84491q.xh83drncrumtuwn1 \
        --discovery-token-ca-cert-hash sha256:ac28b9badf4695c26941770de7bf5989a2a68a3f74e690867397c035e4f93676 \
        --control-plane --certificate-key dd00c39aea73249d1f0ce1eca6f2da0969a774cc2b137aa5b5fec4ae6cefe170`

    join workers to cluster : (possible string like - hashes / tokens / cert may differ) :

    `   kubeadm join 192.168.1.100:6443 --token 84491q.xh83drncrumtuwn1 \
        --discovery-token-ca-cert-hash sha256:ac28b9badf4695c26941770de7bf5989a2a68a3f74e690867397c035e4f93676`


6. install calico .. after installing all masters 

    on master-01:

    `CNI_VER=3.28.0`

    `kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v${CNI_VER}/manifests/tigera-operator.yaml`

    next download custom resources file

    `wget https://raw.githubusercontent.com/projectcalico/calico/v${CNI_VER}/manifests/custom-resources.yaml`

    `vi custom-resources.yaml'

    replace cidr with 10.100.0.0/16 and then create custom resource (or replace if existing)

    `kubectl create -f custom-resources.yaml`