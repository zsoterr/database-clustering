Steps of deployment:

I. Master node:
- create a new image using Dockerfile: for example: docker build -t  awx-v9-psql-v10-master:1 . -you will use this image in docker compose file
- create the necessary paths:
 /srv/awx/pgdocker
- set the image name, username and passwords (db user,replica user,report user) ,db name,timezone of container and postgresql - in .env file
- if you want to use different IP address for master node: edit compose file: edit or remove this part:
        ipv4_address: 172.25.0.2
- the master node's psql port will be published for external network, if this is not fit for you, edit the compose file before the deplyoment: comment these:
    ports:
      - "5432:5432"
- edit or remove limits - as you want - ,here 
        limits:
          cpus: '0.9'
          memory: 700M
- edit the subnet based on your requirement, here:
        - subnet: 172.25.0.0/16
- deploy master db instance using compose file: docker-compose --compatibility up -d

II. Slave node:
Based on same image as master container, with a small variation: has been prepared for slave role.
We will create a psql container (using new image) with slave role and place it same network as master node:
- create a new image using Dockerfile: for example: docker build -t  awx-v9-psql-v10-slave:1 . -you will use this image in docker compose file
- create the necessary paths:
 /srv/awx/pgdocker2
- set the image name, username and passwords,db name,timezone of container and postgresql - in .env file
- if you want to use different IP address for master node: edit compose file: edit or remove this part:
        ipv4_address: 172.25.0.3
- the slave node's psql port will be published for external network, if this is not fit for you, edit the compose file before the deplyoment: comment these:
    ports:
      - "15432:5432"
- edit or remove limits - as you want - ,here
        limits:
          cpus: '0.8'
          memory: 600M
- deploy the slave db instance using compose file: docker-compose --compatibility up -d

III. PgAdmin:
We will create a pgadmin container and place it same network as master node:
- read the readme file within pgadmin directory,
- edit the enx.txt
- run the script

IV. ClusterControl:
- deploy the ClusterControl: check and read the README.md within clustercontrol directory
- if you want ensure if ssh service is up an running, you can use crontab (I know this is not the best solution. I tend to fix this later. ) on host level., for example:
 crontab.example: as example:  using crontab on host level, for example: running this command:  crontab -e
 start-cron.sh : copy this script to next path: /usr/local/bin and edit the file -if necessary- (for example: add more slave node to this script)
