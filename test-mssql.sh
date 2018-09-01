#!/usr/bin/env bash

docker run \
  --rm \
  --name mssql-test \
  -e ACCEPT_EULA=Y \
  -e SQL_USER=docker \
  -e SQL_PASSWORD=docker \
  -e SQL_DB=docker \
  -e LOG_LEVEL=DEBUG \
  -p 1433:1433 \
  topaztechnology/mssql-server-linux:latest
