#!/bin/sh

echo "--------------------------------------------------"
echo "If the return value is  0, that means: it is OK."
echo "--------------------------------------------------"

echo "Set the password for root user:"
docker exec -ti awx-postgres service ssh start
echo "$?"
docker exec -it awx-postgres systemctl enable ssh
echo "$?"
docker exec -it awx-postgres passwd
echo "$?"
