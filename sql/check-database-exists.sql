SET NOCOUNT ON

SELECT COUNT(*) FROM sys.databases WHERE name = '${DB_NAME}'
