function runSqlScript {
  SQL_FILE=$(mktemp -t XXXXXXXX.sql)
  envsubst < "$1" > "${SQL_FILE}"
  /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P "${SA_PASSWORD}" -b -i "${SQL_FILE}" > /dev/null 2>&1
  rm "${SQL_FILE}"
}
