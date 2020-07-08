#!/bin/sh
#We will put the container to same network where awx psql container is available

# Define the variables:
PORT_EXPOSE_HTTP=80
PORT_EXPOSE_HTTPS=443

# Start the container
docker run -d --name clustercontrol --network master_awx-v9-postgres_nw -p 5000:$PORT_EXPOSE_HTTP -p 5001:$PORT_EXPOSE_HTTPS \
-v /srv/awx/cluster-control/storage/clustercontrol/cmon.d:/etc/cmon.d \
-v /srv/awx/cluster-control/storage/clustercontrol/datadir:/var/lib/mysql \
-v /srv/awx/cluster-control/storage/clustercontrol/sshkey:/root/.ssh \
-v /srv/awx/cluster-control/storage/clustercontrol/cmonlib:/var/lib/cmon \
-v /srv/awx/cluster-control/storage/clustercontrol/backups:/root/backups \
severalnines/clustercontrol:1.7.6
