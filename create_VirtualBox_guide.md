# General section on creating VirtualBox for use with Vagrant


## 1. Creating VirtualBox boxes general guidline

For latest information please refer to :
- [Creating a Base Box](https://developer.hashicorp.com/vagrant/docs/boxes/base)
- [Creating a Base Box - VirtualBox provider](https://developer.hashicorp.com/vagrant/docs/providers/virtualbox/boxes#to-install-via-the-command-line)

Preparing box that might be used with Vagrant consist of few repetetive steps: (as a example building of ubuntu-24-04-server)

- preparing /or adjusting OS image:
    - get desired OS image and install it on VirtualBox (skip if you already installed OS image),
    - run OS image and log into,
    - made adjustments and configurations,
    - save state of OS image - re-run OS image - and then turn off VM holding this image
- prepare (package) the OS image to Vagrant format (box):
    - `vagrant box list` - with this command you can check boxes already imported and ready to use in Vagrant
    - if you got previous version of box and want to update:
        - `vagrant box remove ubuntu-24-04-server` - with this command you remove the box from Vagrant's box list
        - remove ubuntu-24-04-server.box file 
    - `vagrant package --base ubuntu-24-04-server --output ubuntu-24-04-server.box` - this will take some time to export your VM into box format
- add / update Vagrant box :
    - `vagrant box add --name ubuntu-24-04-server .\ubuntu-24-04-server.box` - with this command you import box into Vagrant

Now you are ready to run vagrant with `vagrant up --provider=virtualbox`
In order to make adjustment just follow this steps one more time.


## 2. Details of VirtualBox format

In order to make it work with Vagrant:

- set correct networks so that:
    - vm got two network interfaces: 
        - enp0s3 -> with NAT type (which is required by vagrant to connect into VM)
        - enp0s8 -> with Briged type - for your purposes assure that listening type is 'allowed to all'

    - while running:
        - i turn off enp0s3 - configuring correctly DNSes and routes (now only enp0s8 will work)

- create user vagrant (with password : vagrant ) and copy & paste ssh keys into vagrant user's directory ~/.ssh into file authorized_keys:
    [Vagrant public keys to copy & paste](https://github.com/hashicorp/vagrant/blob/main/keys/vagrant.pub)

- install VirtualBox Guest Additions - to make your VM work with Vagrant [VirtualBox Guest Additions](https://developer.hashicorp.com/vagrant/docs/providers/virtualbox/boxes#additional-software)