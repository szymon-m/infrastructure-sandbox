### Ansible AWX setup - with simple k8s cluster - 1 control plane - and 2 workers

| **Role**         | **FQDN**                   | **IP**           | **OS**         | **RAM** | **CPU** |
|------------------|----------------------------|------------------|----------------|---------|---------|
| Master           | master-01                  | 192.168.1.101    | Ubuntu 24.04   | 8G      | 4       |
| Worker           | worker-01                  | 192.168.1.201    | Ubuntu 24.04   | 4G      | 4       |
| Worker           | worker-02                  | 192.168.1.202    | Ubuntu 24.04   | 4G      | 4       |

1. start `vagrant up --provider=virtualbox`
2. login as atos/student - then use sudo -i - to switch to root: 

    `./setup.sh` - > to configure network interfaces

    `./preconfigure.sh` -> to configure kernel modules, packages, container runtime and binaries for Kubernetes cluster

3. launch kubernetes init on master-01:
      
    `kubeadm init --pod-network-cidr=10.100.0.0/16`
    
    after successfull initialization of cluster:
    
    `mkdir -p $HOME/.kube`

    `cp -i /etc/kubernetes/admin.conf $HOME/.kube/config`

    now you can use kubectl

4. install Cilium network plugin after installing master-01:

    `curl -LO https://github.com/cilium/cilium-cli/releases/latest/download/cilium-linux-amd64.tar.gz`

    `tar xzvfC cilium-linux-amd64.tar.gz /usr/local/bin`

    `cilium install`

5. join workers to cluster : (possible string like - hashes / tokens / cert may differ) :

    `kubeadm join 192.168.1.101:6443 --token 84491q.xh83drncrumtuwn1 --discovery-token-ca-cert-hash sha256:ac28b9badf4695c26941770de7bf5989a2a68a3f74e690867397c035e4f93676`


6. to install AWX follow this guidline from this page - [AWX basic install](https://ansible.readthedocs.io/projects/awx-operator/en/latest/installation/basic-install.html)

    - on `master-01`: create awx namespace : `kubectl create ns awx`
    - create persistent volume - create file `awx-pv.yaml` (check in repository) and run `kubectl apply -f awx-pv.yaml` - that one will create pv on worker-02 - assure that there is enough storage space (vagrant box image with 10GB is not sufficent - i need to create another ubuntu image with)

    - create persistent volume claim - create file `awx-pvc.yaml` (check in repository) and run `kubectl apply -f awx-pvc.yaml` - 
    - check with `kubectl get pv,pvc -n awx` whether new pv and pvc were created and are binded 
    - log into `worker-02` and create directories and change owner [postgres-issue-comments](https://github.com/ansible/awx-operator/issues/1770#issuecomment-1998473922) : 

    ```
    mkdir -p /mnt/disk/data
    chown -R 26:26 /mnt/disk    
    ```

    - go back to `master-01` - create `kustomization.yaml` (check in repository)
    - run `kubectl apply -k .` in directory containinig kustomization.yaml

    - read port exposed by awx-demo-service : `kubectl get services -n awx` - > port should be like 32132/TCP
    - read AWX admin password with : `kubectl -n awx get secret awx-demo-admin-password -o jsonpath="{.data.password}" | base64 --decode ; echo`
    - log into your AWX local instance (if you got bridged connection on your VMs in Virtualbox) - > in my case it is : [http://192.168.1.101:32134](http://192.168.1.101:32134) use admin as login and first admin password retrieved in previous step