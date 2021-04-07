#!/bin/sh
docker-compose -f docker-compose.yml rm -f postgres raw-storage raw-creds raw-executor raw-frontend

./run.sh up
