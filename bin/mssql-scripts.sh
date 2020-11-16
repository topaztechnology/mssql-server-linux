#!/bin/bash

source /opt/mssql-init/bin/mssql-cmd.sh

shopt -s nullglob
echo "Looking for scripts in /init.sql/*.sql"
for SQL_FILE in /init.sql/*.sql
do
  echo "Running SQL script ${SQL_FILE}"
  envsubst < "${SQL_FILE}" > /tmp/sql-script.sql
  runSqlScript /tmp/sql-script.sql
  rm /tmp/sql-script.sql
done
