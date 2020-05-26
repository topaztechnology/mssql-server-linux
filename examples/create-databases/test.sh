#!/bin/bash

docker build -t create-databases-example:latest .

docker run -e 'ACCEPT_EULA=Y' -e 'MY_DB1=mydb1' -e 'MY_DB2=mydb2' -p 1433:1433 create-databases-example:latest
