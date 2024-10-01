## installed Vagrant on local Ubuntu WSL2 

## RESULTS
----------------------------------------------------------------------------------------------
abandoned - due lot of dependencies and hard configuration of WSL <-> Virtualbox <-> Vagrant
moved to simple git repository and plain Windows binary installation of Vagrant
please check : 01-vagrant-on-local-Windows-binary-Vagrant
----------------------------------------------------------------------------------------------

Prerequisites:
1. VirtualBox installed
2. Turned of Hyper-V on Windows (in Programs and App features - turn of Hyper-V and restart)


1. From Windows menu start - type wsl - and run WSL
2. in WSL console: 
   1. cd   -> to move to home directory
   2. mkdir infrastructure 
   3. cd infrastructure
   4. code .   -> to run Vscode with WSL:Ubuntu enabled
3. turn off VPNs
4. in VScode terminal:
   1. git clone https://github.com/szymon-m/infrastructure-sandbox.git
   2. cd infrastructure
   3. install vagrant
   4. wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
   5. echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/ources.list.d/hashicorp.list
   6. sudo apt update && sudo apt install vagrant
   7. check documentation https://developer.hashicorp.com/vagrant/docs/other/wsl
   8. export VAGRANT_WSL_ENABLE_WINDOWS_ACCESS="1"
   9. export PATH="$PATH:/mnt/c/Program Files/Oracle/VirtualBox"
   
5.  start code :
    1.  in VScode terminal:
        1.  vagrant init hashicorp/bionic64
        2.  vagrant up
   
            error: 

            Bringing machine 'default' up with 'libvirt' provider...
            Error while connecting to libvirt: Error making a connection to libvirt URI qemu:///system?no_verify=1&keyfile=/home/szymon/.ssh/id_rsa:
            Call to virConnectOpen failed: Failed to connect socket to '/var/run/libvirt/libvirt-sock': No such file or directory
        3. 



