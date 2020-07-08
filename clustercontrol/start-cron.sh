#!/bin/sh

containerlist=( awx-postgres awx-postgres-slv_1 )
for i in "${containerlist[@]}"
do
   docker exec -i "${i}" bash -c "service ssh start"
done

