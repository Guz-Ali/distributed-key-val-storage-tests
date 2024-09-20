
# Distributed key-val I/O Benchmark
empirical analysis of distributed key-value storage systems in MongoDB and Cassandra

### Environment Setup

#### Linux-Ubuntu VM Setup

First-time setup: 
- `sudo lxd init`

Launching a VM is as easy as: 
- `sudo lxc launch images:ubuntu/22.04 <VM Name> --vm -c limits.cpu=4 -c limits.memory=4GiB`

Modify firewall rules:
- `sudo ufw allow in on lxdbr0` (maybe lxdfan0 too)
- `sudo ufw route allow in on lxdbr0`
- `sudo ufw route allow out on lxdbr0`

Shell Access: (To ssh, requires installing openssh-server on target VM) 
- `sudo lxc shell <VM Name>`

#### Connecting VMs
- Install openssh-client and server on both vms. `sudo apt install openssh-client` and `sudo apt install openssh-server`
- Navigate to `/etc/ssh/sshd_config` and change to `RootLogin yes`.
- Generate public key with `ssh-keygen`. Copy public key (in id_rsa.pub) to `~/.ssh/authorized_keys` in the other VM.
- Now generate public key in the other VM, and copy public key to this VM.
- VMs should now be able to connect to each other with just `ssh ip_number` (instead of ssh user@ip_number)
- To add all ssh connections, save the public keys in a text file and copy it to all VMs' authorized_keys file.
- Take a look at `scripts/connect-instances.sh` to see how to do them all the steps at once for an instance. Do not run this script as it doesn't work as intended. Instead use the code to setup ssh and pass public keys between instances.

#### Setting up Cassandra
- Here we will set up Cassandra servers on all instances
- Direct to scripts folder with `cd scripts`
- First run: `sh run-script-on-all-VMs.sh setup-cassandra.sh`. This will setup Cassandra on all instances.
- Connect to `small-instance-1` and configure with `vim /etc/hosts` to add all IP addresses for all instances
- Configure the same file for all instances but only change the small-instance-x ip address to its own ip address.
- In each instance, configure inside cassandra folder `conf/cassandra.yaml` to change listen_address, rpc_address to "small-instance-x", and seed to the ip address of small-instance-x.
- In each instance, start Cassandra by running from the cassandra folder: `bin/cassandra` (might require -R option to run as root). 
- Run from the cassandra folder: `bin/nodetool status` to see active or down cassandra servers.

#### Running Cassandra Tests
- To run the cassandra tests, simply run `python3 test-cassandra-x.py {1,2,4,8}`
- These will output the tests results to command line. You can also run with `>> logfile.log` to pass results into a log file.

#### Stopping Cassandra Servers
- Use the following lines of code to stop any Cassandra process: 
- ``` user=`whoami` ```
- ` pgrep -u $user -f cassandra | xargs kill -9 `
- OR
- use stop-cassandra.sh together with run-script-on-all-VMs.sh like this: `sh run-script-on-all-VMs.sh stop-cassandra.sh`

#### Setting up MongoDB
- Follow installation instructions on https://www.mongodb.com/docs/manual/tutorial/install-mongodb-on-ubuntu/
- Configure instance ulimit settings as described in https://www.mongodb.com/docs/manual/reference/ulimit/
- OR
- use scripts/setup-mongodb.sh together with run-script-on-all-VMs.sh like this to set it up for all instances: `sh run-script-on-all-VMs.sh setup-mongodb.sh`  (first navigate to scripts folder)
- After installations are complete, go into each instance and configure `/etc/mongod.conf`. You'll need to change bind ip address.
- Useful resource for starting MongoDB on all instances: https://computingforgeeks.com/how-to-setup-mongodb-replication-on-ubuntu/
- Deploying a Replica Set: https://www.mongodb.com/docs/manual/tutorial/deploy-replica-set/
- Deploying a Replica Set 2: https://www.mongodb.com/docs/manual/tutorial/deploy-replica-set-for-testing/
- Install `mongocxx` to use C++ with MongoDB: https://mongocxx.org/


#### Resources:

- Cassandra: `https://cassandra.apache.org/doc/latest/`
- MongoDB: `https://www.mongodb.com/docs/manual/tutorial/install-mongodb-on-ubuntu/`
- MongoDB replica installation: `https://computingforgeeks.com/how-to-setup-mongodb-replication-on-ubuntu/`
