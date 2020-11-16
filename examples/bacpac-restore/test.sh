#!/bin/bash

docker build -t restore-bacpac-example:latest .

docker run -p 1433:1433 restore-bacpac-example:latest
