USE ${SQL_DB};
GO
IF NOT EXISTS(SELECT * FROM sys.database_principals WHERE name = '${SQL_USER}')
  CREATE USER ${SQL_USER} FOR LOGIN ${SQL_USER} WITH DEFAULT_SCHEMA = dbo
GO
EXEC sp_addrolemember 'db_owner', '$SQL_USER';
GO
