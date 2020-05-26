#!/bin/bash
set -eo pipefail

SQL_USER_CREATED=0

if [[ ! -z "${SQL_USER}" && ! -z "${SQL_PASSWORD}" ]]; then
  # Create login
  cat >> /tmp/create-user.sql <<-EOF
IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = '${SQL_USER}')
	CREATE LOGIN ${SQL_USER} WITH PASSWORD = '${SQL_PASSWORD}', CHECK_POLICY = OFF
GO
EOF
  echo Creating login ${SQL_USER}
  /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P ${SA_PASSWORD} -b -i /tmp/create-user.sql > /dev/null 2>&1
  SQL_USER_CREATED=1
fi

if [[ ! -z "${SQL_DB}" ]]; then
  # Create database
  cat >> /tmp/create-db.sql <<-EOF
IF NOT EXISTS(SELECT * FROM sys.databases WHERE name = '${SQL_DB}')
	CREATE DATABASE ${SQL_DB}
GO
EOF

  if [[ "${SQL_USER_CREATED}" -eq 1 ]]; then
    # Create user on database
    cat >> /tmp/create-db.sql <<-EOF
USE ${SQL_DB};
GO
IF NOT EXISTS(SELECT * FROM sys.database_principals WHERE name = '${SQL_USER}')
  CREATE USER ${SQL_USER} FOR LOGIN ${SQL_USER} WITH DEFAULT_SCHEMA = dbo
GO
EXEC sp_addrolemember 'db_owner', '$SQL_USER';
GO
USE master;
GO
EOF
  fi
  echo Creating database ${SQL_DB}
  /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P ${SA_PASSWORD} -b -i /tmp/create-db.sql > /dev/null 2>&1
fi

shopt -s nullglob
echo Looking for scripts in /init.sql
for SQL_FILE in /init.sql/*.sql
do
  echo Running SQL script $SQL_FILE
  
  # Basic templating with bash substitutions
  echo 'cat <<EOF' > /tmp/sql-script.sh
  cat "$SQL_FILE" >> /tmp/sql-script.sh
  echo 'EOF' >> /tmp/sql-script.sh
  bash /tmp/sql-script.sh >> /tmp/sql-script.sql
  rm /tmp/sql-script.sh

  /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P ${SA_PASSWORD} -b -i /tmp/sql-script.sql
  rm /tmp/sql-script.sql
done
