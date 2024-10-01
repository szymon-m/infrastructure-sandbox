## installing Vagrant with Windows binary 

Prerequisites:
1. VirtualBox installed
2. Turned of Hyper-V on Windows (in Programs and App features - turn of Hyper-V and restart)

1. install vagrant binary from official web page:

        vagrant_2.4.1_windows_amd64.msi  -> Restart required !

2. in VScode terminal:
    1. git clone https://github.com/szymon-m/infrastructure-sandbox.git
    2. vagrant init hashicorp/bionic64
    3. need to downgrade Virtualbox from version 7.1 to 7.0 -> 7.1 not compatibile
    4. possibly need to install pywin32 : open Powershell console (as admin): and launch: pip install pywin32
    5. vagrant up --provider=virtualbox

        VMs are created on VirtualBox

    6. vagrant destroy