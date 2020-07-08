#!/bin/bash
echo "host replication all 0.0.0.0/0 md5" >> "$PGDATA/pg_hba.conf"
set -e
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
CREATE USER $PG_REP_USER REPLICATION LOGIN CONNECTION LIMIT 100 ENCRYPTED PASSWORD '$PG_REP_PASSWORD';
CREATE USER $REPORT_USER WITH PASSWORD '$REPORT_U_PASSWORD';
GRANT SELECT ON ALL TABLES IN SCHEMA public TO $REPORT_USER;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO $REPORT_USER; 
GRANT CONNECT ON DATABASE $POSTGRES_DB TO $REPORT_USER;
EOSQL
cat >> ${PGDATA}/postgresql.conf <<EOF
wal_level = hot_standby
# archive_mode = on
# archive_command = 'cd .'
max_wal_senders = 4
wal_keep_segments = 10
hot_standby = on
EOF
