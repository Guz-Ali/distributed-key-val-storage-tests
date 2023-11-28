for n in 1 2 3 4 5 6 7 8
do
	lxc launch images:ubuntu/22.04 small-instance-$n -c limits.cpu=3 -c limits.memory=12GB --vm
	lxc config device override small-instance-$n root size=24GiB
done

echo "small instances generation complete. Generated 8 instances."

ufw allow in on lxdbr0
ufw route allow in on lxdbr0
ufw route allow out on lxdbr0

ufw allow in on lxdfan0
ufw route allow in on lxdfan0
ufw route allow out on lxdfan0

echo "Completed: network ipv4 allowed."
echo "Please set up ssh connections"
