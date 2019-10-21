#!/bin/sh

# required parameters in ENV:
# SQL_SERVER
# SQL_PASSWORD

sed -i "s/{SQL_SERVER}/$SQL_SERVER/g" ./db-connection-string && \
sed -i "s/{SQL_PASSWORD}/$SQL_PASSWORD/g" ./db-connection-string

connectionString=$(cat db-connection-string)
echo ::set-output name=connectionString::$connectionString