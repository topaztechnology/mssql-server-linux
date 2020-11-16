#!/bin/bash

shopt -s nullglob

function checkDatabaseExists {
  SQL_FILE=$(mktemp -t XXXXXXXX.sql)
  export DB_NAME=$1
  envsubst '${DB_NAME}' < /opt/mssql-init/sql/check-database-exists.sql > "${SQL_FILE}"
  /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P "${SA_PASSWORD}" -b -W -h -1 -i "${SQL_FILE}"
  rm "${SQL_FILE}"
}

echo "Looking for backups in /init.bacpac/*.bacpac"
for BACPAC_FILE in /init.bacpac/*.bacpac
do
  DATABASE_NAME=$(basename ${BACPAC_FILE} | sed 's/\.[^.]*$//')
  DB_EXISTS=$(checkDatabaseExists ${DATABASE_NAME})
  if [[ $DB_EXISTS -ne 0 ]]; then
    echo "Database ${DATABASE_NAME} already exists, not restoring"
  else
    echo "Restoring backup for database ${DATABASE_NAME}"
    /opt/sqlpackage/sqlpackage /a:Import /tsn:localhost /tu:sa /tp:"${SA_PASSWORD}" \
      /tdn:"${DATABASE_NAME}" /sf:"${BACPAC_FILE}"
  fi
done
