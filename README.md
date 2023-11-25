# distributed-key-val-storage-tests
empirical analysis of key-value storage systems

LINUX VM Setup

First-time setup: 
- sudo lxd init
Launching a VM is as easy as:
- sudo lxc launch images:ubuntu/22.04 <VM Name> --vm -c limits.cpu=4 -c limits.memory=4GiB
Modify firewall rules:
- sudo ufw allow in on lxdbr0 (maybe lxdfan0 too)
- sudo ufw route allow in on lxdbr0
- sudo ufw route allow out on lxdbr0
Shell Access: (To ssh, requires installing openssh-server on target VM) 
- sudo lxc shell <VM Name>

Connecting VMs
- Install openssh-client and server on both vms. sudo apt install openssh-client and sudo apt install openssh-server
- Navigate to /etc/ssh/sshd_config and change RootLogin to yes.
- Generate public key with ssh-keygen. Copy public key (in id_rsa.pub) to ~/.ssh/authorized_keys in the other VM.
- Now generate public key in the other VM, and copy public key to this VM.
- VMs should be able to connect to each other with just 'ssh ip_number' (instead of ssh user@ip_number)
- To add all ssh connections, save the public keys in a text file and copy it to all VMs' authorized_keys file.
