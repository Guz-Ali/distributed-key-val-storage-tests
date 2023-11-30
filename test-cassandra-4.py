from cassandra.cluster import Cluster
import csv
import datetime

test_data = []
with open('data/test_data.csv', encoding='utf-8') as f:
     reader = csv.DictReader(f)
     for row in reader:
         test_data.append((row['key'], row['value']))

test_size = len(test_data)
print("test_data size:%d" % test_size)

cluster = Cluster(["240.1.74.50","240.1.74.118","240.1.74.238","240.1.74.68"])
session = cluster.connect()
keyspacename = "kv_space"
session.execute("create keyspace if not exists %s with replication = {'class': 'SimpleStrategy', 'replication_factor': 2};" % keyspacename)
session.set_keyspace(keyspacename)

s = session
s.execute("DROP TABLE IF EXISTS kvpair")
s.execute("CREATE TABLE kvpair (k text PRIMARY KEY, v text)")

# insert benchmark
start = datetime.datetime.now()

for i in range(1000):
    s.execute("INSERT INTO kvpair (k, v) VALUES (%s, %s)", [test_data[i][0], test_data[i][1]])

end = datetime.datetime.now()

insert_time = end - start
print("insert %d items time: %sus" % (test_size, inserttime.microseconds) )

# lookup benchmark
start = datetime.datetime.now()

for i in range(1000):
    s.execute("SELECT k, v from kvpair where k = %s", [test_data[i][0]])

end = datetime.datetime.now()

lookup_time = end - start
print("lookup %d items time: %sus" % (test_size, lookuptime.microseconds) )

# delete benchmark
start = datetime.datetime.now()

for i in range(1000):
    s.execute("DELETE from kvpair where k = %s", [test_data[i][0]])

end = datetime.datetime.now()

delete_time = end - start
print("delete %d items time: %sus" % (test_size, delete_time.microseconds) )

# total time
total_time = insert_time.microseconds + lookup_time.microseconds + delete_time.microseconds; #total_end - total_start
average_time = total_time / 3;

print("total time: %sus" % total_time)
print("average time: %sus" % average_time)


