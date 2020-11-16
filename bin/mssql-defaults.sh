#!/bin/bash

source /opt/mssql-init/bin/mssql-cmd.sh

if [[ -n "${SQL_USER}" && -n "${SQL_PASSWORD}" ]]; then
  echo "Creating login ${SQL_USER}"
  runSqlScript /opt/mssql-init/sql/create-login.sql
  SQL_USER_CREATED=1
fi

if [[ -n "${SQL_DB}" ]]; then
  echo "Creating database ${SQL_DB}"
  runSqlScript /opt/mssql-init/sql/create-database.sql

  if [[ -n "${SQL_USER_CREATED}" ]]; then
    echo "Creating user ${SQL_USER} on database ${SQL_DB}"
    runSqlScript /opt/mssql-init/sql/create-database-user.sql
  fi
fi
