
for i in 3 5 6 7 8
do
  ssh small-instance-$i 'bash -s' < $1
done
