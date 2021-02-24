#!/bin/bash -e
SCRIPT_DIR="$(cd "$(dirname "$0")"; pwd)"
cd "${SCRIPT_DIR}"

. raw-config.sh

docker-compose -f docker-compose.yml rm -f postgres raw-storage raw-creds raw-executor raw-frontend

docker volume create raw_cache

docker pull ${DOCKER_REGISTRY}/raw-driver-docker-compose:${RAW_VERSION}

docker-compose -f docker-compose.yml up
