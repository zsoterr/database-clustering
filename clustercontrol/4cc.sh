#!/bin/sh

# Define a variable which refers to postgresql containers/nodes/hosts as "machine":
containerlist=( awx-postgres awx-postgres-slv_1 )
#name of postgresql master "machine":
master=awx-postgres
#name of ClusterControl "machine":
clusterc=clustercontrol
#Monitoring user of ClusterControl
CC_M_USER=monitor
CC_M_PASSWORD=MonitoringUserPassword
#replicaton user (we can use the replication user - which has been set up for awx deployment - or we can create a new for this purpose:
CC_REP_USER=cmon_replication
CC_REP_PASSWORD=ReplicationUserPassword

read -t 5 -p "Wait for 5 seconds after that we can start to run the script.  -you can interrupt this script using CTRL-C ..."
echo ""

# We will execution the necessry steps for ClusterControl: 
docker exec -it $master  psql -U awx -c "CREATE USER postgres SUPERUSER"
echo "$?"
docker exec -it $master  psql -U awx -c "CREATE ROLE $CC_M_USER WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN ENCRYPTED PASSWORD '$CC_M_PASSWORD'"
echo "$?"
docker exec -it $master  psql -U awx -c "CREATE ROLE $CC_REP_USER WITH REPLICATION LOGIN ENCRYPTED PASSWORD '$CC_REP_PASSWORD'"
echo "$?"

read -t 5 -p "Wait for 5 seconds only -you can interrupt this script using CTRL-C ..."
echo ""

# Start ssh service on affected containers/nodes/hosts and set the password of root
for i in "${containerlist[@]}"
do
   echo "start the ssh service on ${i}"
   docker exec -i "${i}" bash -c "service ssh start"
   echo "$?"
   echo "set the password of root on ${i}"
   echo ""
   docker exec -it "${i}" passwd
   echo "$?"
done

# copy the public key of ClusterControl of container to target "machines":
for i in "${containerlist[@]}"
do
   docker exec -it "${clusterc}" bash -c "ssh-copy-id -f ${i}"
   echo "$?"
done

read -t 5 -p "Wait for 5 seconds, we will update the pg_hba.conf and postgresql.conf files, if you don't want -you can interrupt this script using CTRL-C ..."
echo ""

echo "Update pg_hba.conf "
# update pg_hba.conf  on database node(s):
for i in "${containerlist[@]}"
do
 docker exec -i  "${i}" tee -a /var/lib/postgresql/data/pg_hba.conf < 4pg_hba.txt >/dev/null
 echo "$?"
done

echo "Update postgresql.conf "
# update postgresql.conf on database node(s):
for i in "${containerlist[@]}"
do
 docker exec -i "${i}" tee -a /var/lib/postgresql/data/postgresql.conf < 4postgreslconf.txt  >/dev/null
 echo "$?"
done

# reload the configuration changes on  database node(s)
echo "the database configuration(s) will be reloaded."
read -t 5 -p "Wait for 5 seconds, -if you don't want -you can interrupt this script using CTRL-C ..."
for i in "${containerlist[@]}"
do
docker exec -u postgres -i "${i}"  bash -c "pg_ctl reload"
 echo "$?"
done
