for n in 2 3 4 5 6 7 8
do
	lxc launch images:ubuntu/22.04 small-instance-$n -c limits.cpu=3 -c limits.memory=12GB --vm
	lxc config device override small-instance-$n root size=24GiB

	#lxc network create br-si-$n
	#lxc config device add small-instance-$n eno1 nic nictype=bridged parent=br-si-$n name=eno1

	#lxc start small-instance-$n
done

echo "small instances generation complete. Generated 8 instances."

ufw allow in on lxdbr0
ufw route allow in on lxdbr0
ufw route allow out on lxdbr0

ufw allow in on lxdfan0
ufw route allow in on lxdfan0
ufw route allow out on lxdfan0

echo "Completed: network ipv4 allowed."
