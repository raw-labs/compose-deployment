#!/bin/sh
set -e

# Find root folder
export SCRIPT_DIR="$(cd "$(dirname "$0")"; pwd)"
cd "${SCRIPT_DIR}"

# Setup environment
. ${SCRIPT_DIR}/settings.sh

if [ -z "${RAW_VERSION}" ]
then
	echo "Please set RAW_VERSION, exiting..."
	exit 1
fi

docker-compose -f docker-compose.yml rm -f postgres raw-storage raw-creds raw-executor raw-frontend

docker pull ${DOCKER_REGISTRY}/raw-driver-docker-compose:${RAW_VERSION}

docker-compose -f docker-compose.yml up
