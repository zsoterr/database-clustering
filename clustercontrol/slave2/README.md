Goal: create one container which will be used via ClusterControl to add slave node to cluster.
Installation steps:
- build the new image using Dockerfile
- edit the add-unconfigured-slave.sh -(if needed, for example: name of network,pubilshed port,etc ) amd run the script to deploy the container as "planned slave node" to same network as master node
- visit the page of your deployed ClusterControl and add this node - as slave node - to your cluster. ClusterControl will install everything neccessary packages and configure the enviroment and attach this node to your cluster
- if everthing is success, you can run the post script which will set the timezone within the container (you can edit the file): after-added-2-cc.sh
