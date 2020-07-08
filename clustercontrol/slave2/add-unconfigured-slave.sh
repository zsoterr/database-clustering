#!/bin/bash

#name of the new  postgresql slave "machine":
slave=awx-postgres-slv_2
#name of ClusterControl "machine":
clusterc=clustercontrol

docker run -d --name $slave --expose 5432 -p 25432:5432 --network master_awx-v9-postgres_nw -v /srv/awx/pgdocker3:/var/lib/postgresql/data:Z awx-v9-min-postgres-slave-debian:9.12
echo "$?"
docker exec -it $slave apt-get -y install locales
echo "$?"
docker exec -it $slave localedef -f UTF-8 -i en_US en_US.UTF-8
echo "$?"
echo "ensure if ssh is running"
docker exec -it $slave service ssh start
echo "$?"
docker exec -it $slave service ssh status 
echo "$?"
echo ""
echo "set the password for root user"
docker exec -it $slave passwd
echo "Copy public key of clustercontrol to slave node"
docker exec -it "${clusterc}" bash -c "ssh-copy-id -f ${slave}"
echo "$?"
