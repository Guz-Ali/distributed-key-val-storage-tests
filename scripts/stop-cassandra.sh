# finds cassandra processes and kills them with -9.

user=`whoami`
pgrep -u $user -f cassandra | xargs kill -9
