IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = '${SQL_USER}')
  CREATE LOGIN ${SQL_USER} WITH PASSWORD = '${SQL_PASSWORD}', CHECK_POLICY = OFF
