# Supported tags and respective `Dockerfile` links
* `latest` [(Dockerfile)](https://github.com/topaztechnology/mssql-server-linux/blob/master/Dockerfile) - the latest release
* `2019-CU8` [(Dockerfile)](https://github.com/topaztechnology/mssql-server-linux/blob/2019-CU8/Dockerfile) - release based on 2019-CU8-ubuntu-16.04 image
* `2019-CU4` [(Dockerfile)](https://github.com/topaztechnology/mssql-server-linux/blob/2019-CU4/Dockerfile) - release based on 2019-CU4-ubuntu-16.04 image
* `2019-CU3` [(Dockerfile)](https://github.com/topaztechnology/mssql-server-linux/blob/2019-CU3/Dockerfile) - release based on 2019-CU3-ubuntu-16.04 image
* `2017-CU9` [(Dockerfile)](https://github.com/topaztechnology/mssql-server-linux/blob/2017-CU9/Dockerfile) - release based on 2017-CU9 image

# Overview

A SQL Server for Linux image derived from Microsoft's [SQL Server Linux](https://hub.docker.com/_/microsoft-mssql-server) image, but also the following:

* Creation of a login and database on startup from environment variables
* Restoring of bacpac databases from directory
* Running of SQL scripts from directory

These are useful in devops testing scenarios.

# How to use this image

`docker run -d -e 'SQL_USER=docker' -e 'SQL_PASSWORD=docker' -e 'SQL_DB=docker' -p 1433:1433 -v mssql-data:/var/opt/mssql topaztechnology/mssql-server-linux:latest`

# Environment variables

This phase is run first after server startup.

* **SA_PASSWORD** : if specified, overrides the default sa password. A simple password is specified in the Dockerfile to meet complexity requirements, _override if you need this to be secure_.
* **SQL_USER** : if specified will create a SQL login on master, and also a user on the database if SQL_DB is specified.
* **SQL_PASSWORD** : must be specified if SQL_USER is specified, as the password for this login.
* **SQL_DB** : if specified, will create a database on startup, including a user if SQL_USER and SQL_PASSWORD are specified.

# Backups

Any backups `*.bacpac` found in `/init.bacpac` will be then be restored; the database name used will be the same as the file prefix.

# Initialisation SQL

Finally any scripts `*.sql` found in `/init.sql` will be executed. Any scripts should be idempotent, as they will be called each time the container starts up. Scripts can contain environment variables in standard bash format which will be expanded vy `envsubst` before the script is run, see `examples` directory.
