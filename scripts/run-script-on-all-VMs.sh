for i in 1 2 3 4 5 6 7 8
do
  ssh small-instance-$i 'bash -s' < $1
done
