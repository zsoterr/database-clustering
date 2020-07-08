Installation steps:
- create the neccesary path, for example: /srv/awx/pgadmin-data
- if needed, set the permission 0777 on this directory
- edit the env.txt and set the right variables here (like email address,password,ports: where the container will be reachable, outside, from the world)
We will pass this container to same network as master node, so:
- edit the script and update with right network name, in our case: master_awx-v9-postgres_nw
- run the script
