ClusterControl- installation steps:

Steps:
- create the neccesary directory, for example: /srv/awx/cluster-control/storage/
- edit the cluster-control_install.sh file - if needed (for example: paths,published ports)
- run the cluster-control_install.sh script, thiw will create the container using docker run command and put it same network as postgresql master node
- edit these files: 4pg_hba.txt  4postgreslconf.txt  (if needed). These files contain those parameters which will be inserted to pg_hba.conf and postgresql.conf on database node(s), for example: if needed uncomment this in the 4postgresqlconf.txt: listen_addresses = '*'
- edit (set user name,password,etc) and run the "post script" to start ssh service and set the password of root user and create sql users for CControl, copy public key of CControl to affected "machine(s)": 4cc.sh
- edit: update the monitor user (postgresql_user) and password (postgresql_password) and  replication user and password (repl_password)  and rpc key (9fsisuy03nolw2mt) and  hostname (hostname=affb7a0924c6) with rigth container id (clustercontrol container) and - if needed: the ip address(es) and port(s) of postgresql machine(s)- in the configuration file -  and copy the file (cmon_16.cnf) to next path: /etc/cmon.d/ within clustercontrol container, for example:  docker cp cmon_16.cnf clustercontrol:/etc/cmon.d/
- restart cmon service (or if it's not possible restart the container itself):
 docker exec -i clustercontrol bash -c "service cmon restart" or docker exec -i clustercontrol bash -c "systemctl restart cmon" or docker restart clustercontrol
//ps: sometimes if we use restart option (docker restart...), the container has been stopped but didn't start automatically - we have to start it using docker start clustercontrol command
- check the log file: docker exec -i clustercontrol bash -c "tail -100f /var/log/cmon_16.log"
//name of log file is created based on name of the configuration file: that means, if the configuration file is cmon_16.cnf the log file name is /var/log/cmon_16.log
if you see similar to this, the import is success:
2020-07-07T13:36:53.649Z : (INFO) Configuration loaded.
2020-07-07T13:36:53.650Z : (INFO) Loaded configuration file '/etc/cmon.d/cmon_16.cnf'.
2020-07-07T13:36:53.650Z : (INFO) Starting main loop.
2020-07-07T13:36:53.653Z : (INFO) Looking up host affb7a0924c6.
2020-07-07T13:36:53.653Z : (INFO) Testing connection to mysqld...
2020-07-07T13:36:53.683Z : (INFO) Enterprise version.
2020-07-07T13:36:53.692Z : (INFO) Applying modifications from 'cmon_db_mods_hotfix.sql'.
2020-07-07T13:36:55.299Z : (INFO) Looking up and adding PostgreSQL nodes
2020-07-07T13:36:55.300Z : (INFO) Looking up and adding PostgreSQL server '172.25.0.2:5432'
2020-07-07T13:36:55.302Z : (INFO) Looking up and adding PostgreSQL server '172.25.0.3:5432'
2020-07-07T13:36:55.307Z : (INFO) Managed cluster has been registered - registered cluster id=16

- go to the webportal of ClusterControl and add the postgresql cluster: Global Settings/Cluster Synchronization
if you get "Error: The SecureToken can not be updated." error message please follow these steps:
 jump to clustercontrol container (for example: docker exec -it clusterctonrol bash)
 login to mysql database (using password of cmon user, - you can find here within the clustercontrol container: /etc/cmon.d/cmon.cnf - : mysql -u cmon -p 
 run this query: SELECT cluster_id, token FROM dcps.clusters;
 -->if you get "NULL" as token, you have to set up that manually:  UPDATE dcps.clusters SET token='9fsisuy03nolw2mt' WHERE cluster_id=16;
 //ps: if your cluster id and token is different please use that: you can find these in cmon_16.cnf file
- set the crontab and edit these files - if you want-  based on the example and script: crontab.example, start-cron.sh
- you can add slave node to existing postgresql, using pre-configured environment: check and read the README.md within slave directory
