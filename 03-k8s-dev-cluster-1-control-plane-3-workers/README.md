### simple k8s cluster - 1 control plane - and 3 workers

1. start `vagrant up --provider=virtualbox`
2. login as atos/student - then use sudo -i - to switch to root: then launch /root/configure.sh on every node

    `./configure.sh`

3. launch kubernetes init on master-01:

    ! important add : --api-advertise-address=192.168.0.101 (pointing to master-01) - otherwise initialised kubernetes cluster will make use of IP address taken from first network interface - 10.0.2.101 - other nodes will not be able to access this address

    (01.10.2024 - remarks) no --apiserver-advertise-address clause needed when using public_network bridged  - check Vagrant file
    `kubeadm init --pod-network-cidr=10.100.0.0/16`

4. install calico network plugin (or other for example cilium) after installing master-01:

    on master-01:

    `CNI_VER=3.28.0`

    `kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v${CNI_VER}/manifests/tigera-operator.yaml`

    next download custom resources file

    `wget https://raw.githubusercontent.com/projectcalico/calico/v${CNI_VER}/manifests/custom-resources.yaml`

    edit custom-resources.yaml - > replace cidr with 10.100.0.0/16 and then create custom resource (or replace if existing):
    
    `vi custom-resources.yaml` 

    `kubectl create -f custom-resources.yaml`

5. join workers to cluster : (possible string like - hashes / tokens / cert may differ) :

    `kubeadm join 192.168.1.101:6443 --token 84491q.xh83drncrumtuwn1 --discovery-token-ca-cert-hash sha256:ac28b9badf4695c26941770de7bf5989a2a68a3f74e690867397c035e4f93676`