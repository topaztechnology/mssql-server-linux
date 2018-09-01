# Supported tags and respective `Dockerfile` links
* `latest` [(Dockerfile)](https://github.com/topaztechnology/mssql-server-linux/blob/master/Dockerfile) - the latest release
* `2017-CU9` [(Dockerfile)](https://github.com/topaztechnology/mssql-server-linux/blob/master/Dockerfile) - release based on 2017-CU9 image

# Overview

A SQL Server for Linux image derived from Microsoft's [SQL Server Linux](https://hub.docker.com/r/microsoft/mssql-server-linux/) image, but also allows creation of a login and database on startup. This is useful in devops testing scenarios.

Joyent's [Containerpilot](https://www.joyent.com/containerpilot) is used to manage job scheduling and health checks.

# How to use this image

`docker run -e 'ACCEPT_EULA=Y' -e 'SQL_USER=docker' -e 'SQL_PASSWORD=docker' -e 'SQL_DB=docker' -p 1433:1433 -d topaztechnology/mssql-server-linux:latest`

# Environment variables

* **ACCEPT_EULA** : needs to be set to set to 'Y' to accept the [Microsoft EULA](https://go.microsoft.com/fwlink/?linkid=857698)
* **SA_PASSWORD** : if specified, overrides the default sa password. A simple password is specified in the Dockerfile to meet complexity requirements, _override if you need this to be secure_.
* **SQL_USER** : if specified will create a SQL login on master, and also a user on the database if SQL_DB is specified.
* **SQL_PASSWORD** : must be specified if SQL_USER is specified, as the password for this login.
* **SQL_DB** : if specified, will create a database on startup, including a user if SQL_USER and SQL_PASSWORD are specified.
