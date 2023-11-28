# installs java jdk and cassandra on all instances.
# runs on root
# After installation, go into each instance and configure /etc/hosts, conf/cassandra.yaml
# Then run bin/cassandra to start cassandra on the instance.

sudo -s

apt update -y
apt install openjdk-8-jdk -y
java -version
  
apt install curl -y
curl -OL https://dlcdn.apache.org/cassandra/4.0.11/apache-cassandra-4.0.11-bin.tar.gz
tar xzvf apache-cassandra-4.0.11-bin.tar.gz
  
cd apache-cassandra-4.0.11/
# bin/cassandra &

# bin/nodetool status 
