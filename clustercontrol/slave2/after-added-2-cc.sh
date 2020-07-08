#/bin/bash

#name of the new  postgresql slave "machine":
slave=awx-postgres-slv_2
TZ=Europe/Budapest

docker exec -i $slave bash -c "ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && dpkg-reconfigure -f noninteractive tzdata"
echo "$?"
