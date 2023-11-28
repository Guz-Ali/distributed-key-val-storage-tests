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

Setting up Cassandra
- Here we will set up Cassandra servers on all instances
- First run: sh run-script-on-all-VMs.sh setup-cassandra.sh
- This will setup Cassandra on all instances.
- Connect to small-instance-1 and configure with vim /etc/hosts to add all IP addresses for all instances
- Configure the same file for all instances but only change the small-instance-x ip address to its own ip address.
- In each instance, configure inside cassandra folder conf/cassandra.yaml to change listen_address, rpc_address to small-instance-x, and seed to the ip address of small-instance-x.
- In each instance, start Cassandra by running from the cassandra folder bin/cassandra (might require -R option to run as root). 
- Run from the cassandra folder: bin/nodetool status to see active or down cassandra servers.

Running Cassandra Tests
- To run the cassandra tests, simply run python3 test-cassandra-x.py {1,2,4,8}
- These will output the tests results to command line. I manually pasted them to the log files inside tests.


Setting up MongoDB

