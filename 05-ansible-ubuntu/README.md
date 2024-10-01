## confiure Ansible stack

**Creating ubuntu-24-04-server-ansible image box for VirtualBox and Vagrant**

1. with root user -> create ansible user (ansible-01, vm-01, vm-02, vm-03)   (login: ansible, password: ansible)
2. with ansible user - > generate keys without passphrase : on ansible-01 -> ssh-keygen -t rsa -b 2048 - ~/.ssh/id_rsa
3. with ansible user - > add to ansible user's ~/.bashrc file:
        ```
        if [ -f "$HOME/init_session.sh" ]; then
                . "$HOME/init_session.sh"
        fi
       ```

4. with ansible user - > add new file to ansible home dir ~/init_session.sh and chmod +x init_session.sh:
5. with root user -> apt install python3.12-venv  - missing venv Python module on Ubuntu
6. with root user -> apt install python3-pip      - missing pip Pyhon module on Ubuntu 
7. with root user -> su - ansible
8. `python3.12 -m venv venv-ansible-10-4`  - to create Python virtual environment
9. `source venv-ansible-10-4/bin/activate` - to activate (use) created virtual environment
10. `pip install ansible'                - to install Ansible core
11. 'pip install ansible-lint'          - to install Anisble linter 

*(INFO) full list of packages installed might be seen in file requirements.txt (also possible to use this file with `pip install -f requirements.txt`)*

12. with ansible user - > create ~/ansible.cfg file with host_checking = False
13. with root user -> add configure.sh file for root to have ansible and vm IPs configured with proper IP on interface enp0s3
14. with root user -> set hostname entries resolution in /etc/hosts to be like:
    ```
    192.168.1.101 ansible-01
    192.168.1.201 vm-01
    192.168.1.202 vm-02
    192.168.1.203 vm-03
    ```

15. with ansible user - > copy ansible public keys to all vms (vm-01, vm-02, vm-03) - to authorized keys (TIP: create inventory file "hosts" with inventory group *[vms]* - example below use vms inventory group for all vms)

    ```
    [vms]
    vm-01
    vm-02
    vm-03
    ```

    *(info) that part is done in init_session.sh - on every login to ansible user*

    `ansible vms -m authorized_key -a "user='ansible' state='present' key='{{ lookup('file','.ssh/id_rsa.pub')}}'" -i hosts `


    *(not work) still need to type in password*
    *(workaround) as root _> `apt-get install sshpass`  -> then use in init_session.sh: `sshpass -p ansible ssh-copy-id vm-01`*


    


16. TO-CONSIDER:

    - exchange SSH keys (generate keys on vms and propagate keys using authorized_key Ansible module )
    - add ansible user to sudoers
    - rsync -> in order to push -> playbook starts on vm-02 but delegate PUSH to vm-01 as initiator! so vm-01 - need to have keys copied to target vm-02 - with ssh-copy-id 

17. export VirtualBox package with Vagrant and then add box to Vagrant

    `vagrant package --base ubuntu-24-04-server-ansible --output ubuntu-24-04-server-ansible.box`

    `vagrant box add --name ubuntu-24-04-server-ansible .\ubuntu-24-04-server-ansible.box` 

18. start vagrant

    `vagrant up --provider=virtualbox`