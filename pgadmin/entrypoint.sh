#!/bin/bash

envsubst < /pgadmin4/servers.template.json > /pgadmin4/servers.json

exec /usr/local/bin/python /pgadmin4/pgAdmin4.py
