#lxc exec small-instance-1 -- /bin/bash
touch all_authorized_keys

ssh-keygen
apt install openssh-client -y
apt install openssh-server -y
touch ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
chmod 700 ~/.ssh
cat ~/.ssh/id_rsa.pub >> all_authorized_keys

# first understand the code beneath and then use it from the command line for each instance.
#exit

#for i in {2..8}
#do
#  lxc exec small-instance-$i -- /bin/bash
#  ssh-keygen
#
#  apt install openssh-client -y
#  apt install openssh-server -y
#
#
#  touch ~/.ssh/authorized_keys
#  chmod 600 ~/.ssh/authorized_keys
#  chmod 700 ~/.ssh
#
#  cat ~/.ssh/id_rsa.pub | ssh small-instance-1 -T "cat >> all_authorized_keys"
#  echo "\n" | ssh small-instance-1 -T "cat >> all_authorized_keys"
#  
#  exit
#done

#lxc exec small-instance-1 -- /bin/bash
#cat all_authorized_keys > ~/.ssh/authorized_keys

#for i in {2..8}
#do
#  cat all_authorized_keys | ssh small-instance-$i -T "cat >> ~/.ssh/authorized_keys"
#done

