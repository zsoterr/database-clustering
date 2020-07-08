#!/bin/bash
#We will put the container to same network where awx master psql container is available
# Define the variables:
PORT_EXPOSE_HTTP=81
PORT_EXPOSE_HTTPS=4443

# Start the container
docker run -d --name pgadminv4 -u 5050:5050 --volume=/srv/awx/pgadmin-data:/var/lib/pgadmin --env-file=env.txt --network master_awx-v9-postgres_nw -p $PORT_EXPOSE_HTTP:80 -p $PORT_EXPOSE_HTTPS:443 \
--restart unless-stopped -d dpage/pgadmin4:4.22 
